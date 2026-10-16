/*
Inheritance:
    - we pass shape_t to all of these methods, because we just need the shape virtual table
    - when we need the expanded square methods, we will upcast the shape to a square and call ITS virtual table

*/

#ifndef H_SQUARE
#define H_SQUARE

#include <stdbool.h>

#include <shape.h>  // include only the public stuff

typedef struct square_t square_t;  // data-hide
typedef struct square_vt_t square_vt_t;  // data-hide

square_t* square_t_construct(double x, double y);
square_t* square_t_from_shape_t(const shape_t* this);
shape_t* square_t_to_shape_t(const square_t* this);

// methods
void square_t_destroy(shape_t* this);
double square_t_area(const shape_t* this);
double square_t_perimeter(const shape_t* this);

// needs an expand virtual table
bool square_t_is_square(const shape_t* this);

#endif
