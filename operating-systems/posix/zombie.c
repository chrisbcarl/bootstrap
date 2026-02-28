// mkdir dist
// terminal 1: gcc operating-systems/posix/zombie.c -o dist/zombie && dist/zombie
// terminal 2: ps aux | grep zombie
#include <stdlib.h>  // exit
#include <unistd.h>  // fork
int main() {
  pid_t pid = fork();
  if (pid == 0) {exit(0);}  // generate the pcb
  while(1);  // refuse to wait on child, zombie remains
}