// terminal 1: gcc operating-systems/posix/fork-hard.c -o dist/fork-hard && dist/fork-hard
#include <stdio.h>
#include <unistd.h>
int main() {
    pid_t pid = fork();     // line 1
    if (fork()) {           // line 2
        fork();             // line 3
    }                       // line 4
    if (pid) {              // line 5
        fork();             // line 6
    }                       // line 7
    printf("%d\n", getpid());
}

/*
 --- l1, > 0 --- l2, > 0 --- l3 --- l5, l1 > 0 --- X
                                             + --- X
                              + --- l5, l1 > 0 --- X
                                             + --- X
                     = 0        --- l5, l1 > 0 --- X
                                             + --- X
         = 0 --- l2, > 0 --- l3 --- l5, l1 = 0 --- X
                              + --- l5, l1 = 0 --- X
                     = 0 ---------- l5, l1 = 0 --- X
*/