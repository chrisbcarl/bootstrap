#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include <shape.h>  // the public methods
#include <shape-private.h>  // the private attributes
#include <square.h>

struct square_vt_t {
    const char* class;
    void (*destroy)(square_t*);
    const shape_vt_t* base;
    double (*area)(const shape_t*);
    double (*perimeter)(const shape_t*);
    bool (*is_square)(const shape_t*);
};


const square_vt_t square_vt = {
    .class = "Square",
    .base = &shape_vt,
    .area = square_t_area,
    .perimeter = square_t_perimeter,
    .is_square = square_t_is_square,
};

struct square_t {
    shape_t* base;
};

square_t* square_t_construct(double x, double y) {
    square_t* this = malloc(sizeof(square_t));

    // NOTE: downcast - works because square_vt starts with shape_vt, so it CAN be downcasted
    this->base = shape_t_construct((shape_vt_t*)&square_vt, x, y);

    printf("created square_t 0x%p\n", (void*) this);
    return this;
}
square_t* square_t_from_shape_t(const shape_t* this) {return square_t_construct(this->x, this->y);}
shape_t* square_t_to_shape_t(const square_t* this) {return (shape_t*)this;}

// methods
void square_t_destroy(shape_t *this) {
    shape_t_destroy(this);  // since the start of squares ARE shapes, this works
    free(this);  // cleans the rest
    printf("destroyed square_t 0x%p\n", (void*) this);
}
double square_t_area(const shape_t* this) {return this->x * this->y;}
double square_t_perimeter(const shape_t* this) {return 2 * (this->x + this->y);}

// needs an expand virtual table
bool square_t_is_square(const shape_t* this) {return this->x == this->y;}
