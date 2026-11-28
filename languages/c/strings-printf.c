// gcc languages/c/strings.c -o ./dist/main && ./dist/main
#include <stdio.h>

int main() {
    // https://stackoverflow.com/a/757873
    int max_width, value_to_print;
    max_width = 8;
    value_to_print = 1000;
    printf("%*d\n", max_width, value_to_print);

    // https://stackoverflow.com/a/27067507
    char buffer[20];
    snprintf(buffer, sizeof(buffer), "%d. %s:", 1, "Test");
    printf("'%-*s'\n", 10, buffer);  // specifying length of string
    printf("'%-*s'\n", 10, buffer);  // specifying length of string
    printf("'centered: %-s'\n", buffer);
}