/*
gcc operating-systems/posix/sigaction.c -o dist/main && \
( ./dist/main -d & ) && sleep 0.1 && PID=$(pgrep -f main | head -n 1) && \
    kill -s USR1 $PID && sleep 0.1 && \
    kill -s USR1 $PID && sleep 0.1 && \
    kill -s USR1 $PID && sleep 0.1 && \
    kill -s USR1 $PID && sleep 0.1 && \
    kill -s USR2 $PID && \
    wait


USR2 kills when received because the default handler is TERM
*/

#include <stdio.h>
#include <signal.h>
#include <string.h>
struct sigaction ON_SIGNAL = {0};
void handler(int signo, siginfo_t *info, void *context) {
    printf("%d - %s, signal unsafe print\n", signo, strsignal(signo));
    sigaction(signo, &ON_SIGNAL, NULL);
}
int main() {
    ON_SIGNAL.sa_flags = SA_SIGINFO;
    ON_SIGNAL.sa_sigaction = &handler;
    sigaction(SIGUSR1, &ON_SIGNAL, NULL);
    // sigaction(SIGUSR2, &ON_SIGNAL, NULL);  // kill -s USR2 <pid> will kill it because the default handler insnt overrident
    while (1);  // kill -s USR1 <pid>
}