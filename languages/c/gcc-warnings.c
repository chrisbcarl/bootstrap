/*
gcc -I/languages/c -Wall -Wextra -O2 ./languages/c/gcc-warnings.c -o ./dist/main.exe && ./dist/main.exe
*/
#include <stddef.h>  // size_t

int main() {
    // warning: unused variable ‘i’ [-Wunused-variable]
    #pragma GCC diagnostic ignored "-Wunused-variable"
    int i = 0xFFFFFFFF;
    // #pragma GCC diagnostic ignored "-Wshift-negative-value"
    size_t mask = -1 << 1;  // 0x
    return 0;
}
