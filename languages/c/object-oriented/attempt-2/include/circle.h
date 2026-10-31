/*
Inheritance:
    - we pass shape_t to all of these methods, because we just need the shape virtual table
    - when we need the expanded square methods, we will upcast the shape to a square and call ITS virtual table

*/

#ifndef H_CIRCLE
#define H_CIRCLE

#define M_PI 3.14159265358979323846

typedef struct circle_vt_t circle_vt_t;
typedef struct circle_t circle_t;

shape_t* circle_t_construct(double x, double y, double r);
circle_t* circle_t_from_shape(const shape_t* this);
shape_t* shape_t_from_circle(const circle_t* this);
void circle_t_destroy(shape_t* this);

// methods
void circle_t_print(const shape_t* this);
double circle_t_area(const shape_t* this);
double circle_t_perimeter(const shape_t* this);
double circle_t_get_radius(const shape_t* this);
void circle_t_set_radius(shape_t* this, double radius);

#endif
