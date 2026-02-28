// terminal 1: gcc operating-systems/posix/fork.c -o dist/fork && dist/fork
// 7.-Create a program that spawns 7 children and waits for them.
#include <stdio.h>  // printf
#include <stdlib.h>  // exit
#include <unistd.h>  // fork
#include <sys/wait.h>  // waitpid
int main() {
  for (int i = 0; i < 7; i++) {
    int wstatus;
    pid_t pid = fork();
    if (pid == 0) {exit(0);}
    else {waitpid(pid, &wstatus, 0); printf("%d %d\n", pid, WEXITSTATUS(wstatus));}
  }
}
