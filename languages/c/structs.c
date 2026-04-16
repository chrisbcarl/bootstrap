// gcc languages/c/structs.c -o dist/main && dist/main && echo $?
#include <stdlib.h>

struct WastefulContainer {
    int value;
    char c;
    int otherValue;
    char h;
};

struct BetterContainer {
    int value;
    int otherValue;
    char c;
    char h;
};

struct NoTypeDefNode {
    int value;
    struct NoTypeDefNode* next;
};

typedef struct SelfReferentialNode {
    int value;
    struct SelfReferentialNode* next;
} SelfReferentialNode;


int main(int argc, char *argv[]) {
    struct WastefulContainer wc = {1, '2', 3, '4'};
    struct BetterContainer bc;
    bc.value = 1; bc.otherValue = 2; bc.c = '3'; bc.h = '4';

    struct NoTypeDefNode* ntdn = malloc(sizeof(struct NoTypeDefNode));
    ntdn->next = NULL;

    SelfReferentialNode* srn = malloc(sizeof(SelfReferentialNode));
    srn->next = NULL;

    return 0;
}