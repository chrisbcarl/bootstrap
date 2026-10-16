/*
gcc languages/c/object-oriented/attempt-2/main.c \
    -Ilanguages/c/object-oriented/attempt-2/include \
    -Ilanguages/c/object-oriented/attempt-2/src \
    languages/c/object-oriented/attempt-2/src/shape-private.c \
    languages/c/object-oriented/attempt-2/src/square-private.c \
    -o dist/attempt-2 && dist/attempt-2

    languages/c/object-oriented/attempt-2/src/circle-private.c \
*/

#include <shape.h>
#include <square.h>
#include <circle.h>

int main(int argc, char** argv) {
    shape_t* s0 = shape_t_create(3.14, 6.9);
    shape_t_print(s0);
    shape_t_destroy(s0);

    square_t* sq0 = square_t_construct(1.0, 1.0);
    shape_t* s_sq0 = square_t_to_shape_t(sq0);
    shape_t_print(s_sq0);
    square_t_destroy(s_sq0);

    return 0;
}