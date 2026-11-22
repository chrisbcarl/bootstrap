// gcc languages/c/macros.c -o dist/main && dist/main
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// constant macro
#define PIE 3.14

// function macro
#define hello(str) fprintf(stdout, "hello str\n!")

char BUFFER[64];

// multiline macro
#define die(str) \
    strcpy(BUFFER, str); \
    fputs(BUFFER, stderr); \
    exit(1);

// flags
#define FLAG_Z (1u << 0)  // zero: result == 0
#define FLAG_C (1u << 1)  // carry: unsigned overflow
#define FLAG_O (1u << 2)  // overflow: signed overflow

// nested
#define FLAG_ALL FLAG_Z | FLAG_C | FLAG_O

// function macro
#define ISA_OP(jmp, ops, alu, ins) \
    ((((jmp) & 1u) << 7) | (((ops) & 3u) << 5) | (((alu) & 1u) << 4) | ((ins) & 0xFu)) // Each argument shifted left into its slot and ORed into the 8-bit opcode.

typedef enum {
    OP_HALT = ISA_OP(0, 0, 0, 0),   // not a jump, 0 operands, not an alu thingy, instruction variant # 0
    OP_PUSH = ISA_OP(0, 1, 0, 0),   // not a jump, 1 operands, not an alu thingy, instruction variant # 0
    OP_JUMP = ISA_OP(1, 1, 0, 0),   // IS a jump, 1 operands, not an alu thingy, instruction variant # 0
    OP_LOAD = ISA_OP(0, 2, 0, 0),   // not a jump, 2 operands, not an alu thingy, instruction variant # 0
    OP_NOT = ISA_OP(0, 2, 1, 0),    // not a jump, 2 operands, IS an alu thingy, instruction variant # 0
    OP_CMP = ISA_OP(0, 3, 1, 0),    // not a jump, 3 operands, IS an alu thingy, instruction variant # 0
    OP_ADD = ISA_OP(0, 3, 1, 1),    // not a jump, 3 operands, IS an alu thingy, instruction variant # 1
} opcodes;

// variadic functions
// https://gcc.gnu.org/onlinedocs/cpp/Variadic-Macros.html
// https://gcc.gnu.org/onlinedocs/cpp/Stringizing.html
#define assert(condition, failure_message, ...) \
    if (!(condition)) {fprintf(stderr, failure_message __VA_OPT__(,) __VA_ARGS__); exit(1);}


int main() {
    hello(world);  // expands to `fprintf("hello world\n!")`
    assert (1 + 1 == 2, "otherwise the world doesnt make any %d sense...", 420);
    die("this was fun\n");
}