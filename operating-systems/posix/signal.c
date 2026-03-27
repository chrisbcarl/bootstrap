/*
gcc operating-systems/posix/signal.c -o dist/main && \
( ./dist/main -d & ) && sleep 0.1 && PID=$(pgrep -f main | head -n 1) && \
    kill -s USR1 $PID && sleep 0.1 && \
    kill -s USR1 $PID && sleep 0.1 && \
    kill -s USR1 $PID && sleep 0.1 && \
    kill -s USR1 $PID && sleep 0.1 && \
    kill -s USR2 $PID && \
    wait


USR2 kills when received because the default handler is TERM
*/

// old style, simpler
#include <stdio.h>
#include <signal.h>
#include <string.h>

#ifndef __linux__
#define SIGUSR1 10
#define SIGUSR2 12
#endif

void handler(int signo) {
    printf("%d - %s, signal unsafe print\n", signo, strsignal(signo));
    signal(signo, &handler);
}
int main() {
    signal(SIGUSR1, &handler);
    while (1);  // kill -s USR1 <pid>
}