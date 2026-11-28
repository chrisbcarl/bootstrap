// gcc languages/c/function-pointers.c -o ./dist/main && ./dist/main

#include <stdio.h>
#include <stdbool.h>

bool A() {printf("bool A();\n"); return true;}
bool B() {printf("bool B();\n"); return true;}
bool C(int a, int b) {printf("bool C(%d, %d);\n", a, b); return true;}
bool D(int a, int b) {printf("bool D(%d, %d);\n", a, b); return true;}

bool (*func_array[2]) (int, int) = {C, D};  // it looks weird, yeah

int main() {
    bool (*choice) ();
    bool (*paramed) (int, int);
    int x = 6, y = 9;

    if ( x == 1 ) choice = A;
    else choice = B;

    if ( x == 1 ) paramed = C;
    else paramed = D;

    printf("func dynamic\n");
    choice();
    paramed(x, y);

    printf("func array\n");
    for (size_t i = 0; i < 2; i++) {
        bool (*func) (int, int) = func_array[i];
        func(x, y);
    }

    return 0;
}
