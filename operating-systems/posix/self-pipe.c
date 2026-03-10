// gcc operating-systems/posix/self-pipe.c -o dist/main
/*
gcc operating-systems/posix/self-pipe.c -o dist/main && \
( ./dist/main -d & ) && sleep 0.5 && PID=$(pgrep -f main | head -n 1) && \
    kill -s USR1 $PID && sleep 2 && \
    kill -s USR2 $PID && sleep 0.5 && \
    kill -s TERM $PID && \
    wait
*/

#define _GNU_SOURCE             /* See feature_test_macros(7), pipe2 */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <stdarg.h>
#include <signal.h>
#include <unistd.h>
#include <poll.h>

#define true 1
#define false 0

#ifndef __linux__
#define SIGUSR1 10
#define SIGUSR2 12
#endif

void die(int res, int err_val, char* reason, ...) {
    /**
     * usage:
     *  int res = read(FD_O_NONBLOCK, *buf, 1024);
     *  // die for reasons other than interrupted or would have blocked
     *  die(res, -1, "actual error", EINTR, EWOULDBLOCK);
     * stolen from 2025F Project 7 "handle_errno"
     * @param res       int     - return value of function you're concerned for
     * @param err_val   int     - -1 usually
     * @param reason    char*   - program to user explanation
     * @param ...       int...  - EINTR, EAGAIN, EWOULDBLOCK, etc.
     */
    if (res != err_val) return;

    int err = errno;
    va_list args;
    va_start(args, reason);

    while (1) {
        int errno_constant = va_arg(args, int);  // macro for "next in the list", can be hallucinated
        if (errno_constant < 1 || 133 < errno_constant) { break; }  // this is a hallucination, highest errno is 133, leave variadic scan loop and exit.
        // say retval is -1, and ENOENT is one of the exceptions,
        //      DO NOT EXIT, return if errno is due to ENOENT
        if (err == errno_constant) { return; }
    }
    fprintf(stderr, "ERROR: %d - '%s' caused by %s\n!", err, strerror(err), reason);
    exit(EXIT_FAILURE);
}

// globals
int DEBUG = true;
int SELF_PIPE_FD_W = -1;
int SELF_PIPE_FD_R = -1;
struct sigaction ON_SIGNAL = {0};  // must be global so it can be reset in signal handler

void handle_signals(int signo, siginfo_t *info, void *context) {
    /**
     * usable with sigaction, works as an all-in-one muxer that converts signals into queue items
     */
    if (signo == SIGUSR1) {
        write(SELF_PIPE_FD_W, "W", 1);  // signal-safety(7)
    } else if (signo == SIGUSR2) {
        write(SELF_PIPE_FD_W, "S", 1);  // signal-safety(7)
    } else if (signo == SIGTERM) {
        write(SELF_PIPE_FD_W, "E", 1);  // signal-safety(7)
        if (DEBUG) fprintf(stdout, "DEBUG: SIGTERM detected (this print not signal-safe)\n");
    }

    // restore the signal handler (otherwise its a handle-once, get out kind of deal)
    if (-1 == sigaction(signo, &ON_SIGNAL, NULL)) {    // signal-safety(7)
        _exit(EXIT_FAILURE);  // trully the end of the world if sigaction fails to reset the signal...
    };
}


int main(int argc, char** argv) {
    // set up the pipe
    int pipefd[2];  // pipefd[0] refers to the read end of the pipe.  pipefd[1] refers to the write end of the pipe.
    die(pipe(pipefd), -1, "pipe");  // pipe2(pipefd, O_NONBLOCK)  // i argue this is cleaner, doesnt require ppoll, perhaps not as efficient?

    SELF_PIPE_FD_R = pipefd[0];
    SELF_PIPE_FD_W = pipefd[1];

    // set up signal regime
    sigset_t sa_everything;
    sigfillset(&sa_everything);
    sigdelset(&sa_everything, SIGINT);  // leave sigint intact for the love of god
    sigprocmask(SIG_BLOCK, &sa_everything, NULL);  // will be unblocked right as we launch mainloop

    sigset_t sa_mask;
    sigemptyset(&sa_mask);
    sigaddset(&sa_mask, SIGUSR1);
    sigaddset(&sa_mask, SIGUSR2);
    sigaddset(&sa_mask, SIGTERM);

    // set up the handlers
    ON_SIGNAL.sa_flags = SA_SIGINFO;
    ON_SIGNAL.sa_sigaction = &handle_signals;
    die(sigaction(SIGUSR1, &ON_SIGNAL, NULL), -1, "sigaction(SIGUSR1)");
    die(sigaction(SIGUSR2, &ON_SIGNAL, NULL), -1, "sigaction(SIGUSR2)");
    die(sigaction(SIGTERM, &ON_SIGNAL, NULL), -1, "sigaction(SIGTERM)");

    // ready to run, alrm/usr1/usr2/term all active.
    sigprocmask(SIG_UNBLOCK, &sa_mask, NULL);

    // flags
    char* buffer = calloc(1, sizeof(char));   // its a buffer of 1 character from the pipe...
    nfds_t nfds = 1;
    struct pollfd* fds = calloc(nfds, sizeof(struct pollfd));  // normally this list'd be longer...
    fds[0].fd = SELF_PIPE_FD_R;
    fds[0].events = POLLIN | 0;  // only interested in read-ready flag, you can add more
    struct timespec ppoll_ts = {0, 100000};  // tv_sec, tv_nsec (timeout after 1ms)

    // mainloop
    int EXIT = false;
    while (!EXIT) {
        die(ppoll(fds, nfds, &ppoll_ts, &sa_mask), -1, "ppoll");  // blocks till signal, timeout, or POLLIN
        if (!(fds[0].revents & POLLIN)) continue;  // continue if !POLLIN, got timeout or signal instead

        sigprocmask(SIG_BLOCK, &sa_mask, NULL);  // critical section enter, block
        die(read(SELF_PIPE_FD_R, buffer, 1), -1, "read");
        if (*buffer == 0) continue;  // its the null char, probably what the pipe was initialized to

        switch (*buffer) {
            case 'E': {
                if (DEBUG) fprintf(stdout, "DEBUG: SIGTERM detected (this print IS signal-safe)\n");
                fprintf(stdout, "TERM\n");
                EXIT = true;
                break;
            }
            case 'S': {
                fprintf(stdout, "USR2\n");
                break;
            }
            case 'W': {
                fprintf(stdout, "USR1\n");
                break;
            }
            default: {
                fprintf(stderr, "ERROR: buff - '%c'\n", *buffer);
                die(-1, -1, "we shouldnt be here");
                break;
            }
        }
        if (DEBUG) fprintf(stdout, "DEBUG: .pop() -> '%c'\n", *buffer);
        sigprocmask(SIG_UNBLOCK, &sa_mask, NULL);  // critical section exit, unblock
    }

    fprintf(stdout, "DONE\n");
    return EXIT_SUCCESS;
}