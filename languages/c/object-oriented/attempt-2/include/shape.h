/*
Encapsulation:
    - Data and Behavior:
        - Data Hiding:
            - shape_t is an "incomplete type", so it is completely unusable to modify directly when someone wants to #include <shape.h>
            - but, by #include <shape.h>, the user gets all of the "methods"
        - Behavior
            - all methods are shape_t_methodname(*this). There's no way around it because obj.method() doesnt work.
*/

#ifndef H_SHAPE
#define H_SHAPE

typedef struct shape_vt_t shape_vt_t;  // data-hiding
typedef struct shape_t shape_t;  // data-hiding

// behavior
shape_t* shape_t_construct(const shape_vt_t* vt, double x, double y);
shape_t* shape_t_create(double x, double y);
void shape_t_destroy(shape_t* this);
double shape_t_get_x(const shape_t* this);
void shape_t_set_x(shape_t* this, double value);
double shape_t_get_y(const shape_t* this);
void shape_t_set_y(shape_t* this, double value);
double shape_t_area(const shape_t* this);
double shape_t_perimeter(const shape_t* this);
void shape_t_print(const shape_t* this);

#endif
