// terminal 1: gcc operating-systems/posix/orphan.c -o dist/orphan && dist/orphan
// terminal 2: ps aux | grep orphan
// pkill orphan  # must kill separately
#include <unistd.h>  // fork
int main() {
  pid_t pid = fork();
  if (pid == 0) {while(1);}  // generate the orphan
  // parent dies
}