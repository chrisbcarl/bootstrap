/*
gcc languages/c/object-oriented/attempt-2/main.c \
    -Ilanguages/c/object-oriented/attempt-2/include \
    -Ilanguages/c/object-oriented/attempt-2/src \
    languages/c/object-oriented/attempt-2/src/shape-private.c \
    languages/c/object-oriented/attempt-2/src/square-private.c \
    languages/c/object-oriented/attempt-2/src/circle-private.c \
    -o dist/attempt-2 && dist/attempt-2

*/

#include <stdio.h>
#include <stdlib.h>

#include <shape.h>
#include <square.h>
#include <circle.h>

int main(int argc, char** argv) {
    shape_t* s0 = shape_t_create(3.14, 6.9);
    // encapsulation
    shape_t_print(s0);
    shape_t_destroy(s0);

    // inheritance
    shape_t* sq0 = square_t_construct(1.0, 1.0);  // a square SHAPE
    // polymorphism
    shape_t_print(sq0);
    printf("area: %0.3f\n", shape_t_area(sq0));
    printf("perimeter: %0.3f\n", shape_t_perimeter(sq0));
    printf("perimeter: %0.3f\n", square_t_perimeter(sq0));  // same behavior
    printf("is_square: %d\n", square_t_is_square(sq0));
    // data-hiding
    printf("sq0.x = %0.3f\n", shape_t_get_x(sq0));
    square_t_destroy(sq0);

    shape_t* c0 = circle_t_construct(2.0, 3.0, 3.14);  // a circle SHAPE
    shape_t_print(c0);
    printf("area: %0.3f\n", shape_t_area(c0));
    printf("perimeter: %0.3f\n", shape_t_perimeter(c0));
    printf("perimeter: %0.3f\n", circle_t_perimeter(c0));  // same behavior
    printf("c0.r = %0.3f\n", circle_t_get_radius(c0));
    circle_t_destroy(c0);

    return EXIT_SUCCESS;
}