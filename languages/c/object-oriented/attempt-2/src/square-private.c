/*
Inheritance
    - "is-a" relationship
    - "is-a" and more, so the derived should START WITH all of the physical base
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include <shape.h>  // the public methods
#include <shape-private.h>  // the private attributes
#include <square.h>

const shape_vt_t shape_vt_square = {
    .class = "Square",
    .destroy = square_t_destroy,
    .get_x = shape_t_get_x,
    .set_x = shape_t_set_x,
    .get_y = shape_t_get_y,
    .set_y = shape_t_set_y,
    .print = shape_t_print,
    .area = square_t_area,
    .perimeter = square_t_perimeter,
};

struct square_vt_t {
    bool (*is_square)(const shape_t*);
};

const square_vt_t square_vt = {
    .is_square = square_t_is_square,
};

struct square_t {
    shape_t base;  // "is-a" -- derived's first data IS its base
    const square_vt_t* vt;  // base has its own behavior, square has new behavior
};

shape_t* square_t_construct(double x, double y) {
    square_t* this = malloc(sizeof(square_t));
    this->base = *shape_t_construct(&shape_vt_square, x, y);
    this->vt = &square_vt;

    printf("created square_t 0x%p\n", (void*) this);
    return (shape_t*)this;
}
square_t* square_t_from_shape_t(const shape_t* this) {return (square_t*)square_t_construct(this->x, this->y);}
shape_t* square_t_to_shape_t(const square_t* this) {return shape_t_construct(&shape_vt, this->base.x, this->base.y);}

// methods
void square_t_destroy(shape_t* this) {
    // shape_t_destroy(this);  // either this or free
    free(this);  // same size as shape
    printf("destroyed square_t 0x%p\n", (void*) this);
}
double square_t_area(const shape_t* this) {
    return this->x * this->y;
}
double square_t_perimeter(const shape_t* this) {
    return 2 * (this->x + this->y);
}

// needs an expanded virtual table
bool square_t_is_square(const shape_t* this) {
    return this->x == this->y;
}
