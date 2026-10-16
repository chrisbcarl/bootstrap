/*
Encapsulation:
    - Data Hiding:
        - everything in src is private, since these files are not bundled with releases of compiled libs
        - as such, we have access to the entire shape_t struct as usual
*/

#include <stdio.h>
#include <stdlib.h>

#include <shape-private.h>  // NOTE: NOT shape.h

/*
NOTE: THERE IS NO DEFINED SHAPE VIRTUAL TABLE, that's for all of the other classes to decide.
shape_vt will remain here as a base for derived class virtual tables
*/

const shape_vt_t shape_vt = {
    .class = "Shape",
    .destroy = shape_t_destroy,
    .get_x = shape_t_get_x,
    .set_x = shape_t_set_x,
    .get_y = shape_t_get_y,
    .set_y = shape_t_set_y,
    .print = shape_t_print,
    .area = shape_t_area,
    .perimeter = shape_t_perimeter,
};

shape_t* shape_t_construct(const shape_vt_t* vt, double x, double y) {
    shape_t* this = malloc(sizeof(shape_t));
    this->vt = vt;
    this->x = x;
    this->y = y;
    printf("created shape_t 0x%p\n", (void*) this);
    return this;
}
shape_t* shape_t_create(double x, double y) {
    return shape_t_construct(&shape_vt, x, y);
}
void shape_t_destroy(shape_t* this) {
    free(this);
    printf("destroyed shape_t 0x%p\n", (void*) this);
}
// defined
double shape_t_get_x(const shape_t* this) {return this->x;}
void shape_t_set_x(shape_t* this, double value) {this->x = value;}
double shape_t_get_y(const shape_t* this) {return this->y;}
void shape_t_set_y(shape_t* this, double value) {this->x = value;}
void shape_t_print(const shape_t* this) {printf("%s<%0.3f, %0.3f>\n", this->vt->class, this->x, this->y);}
// virtual
double shape_t_area(const shape_t* this) {return this->vt->area(this);}
double shape_t_perimeter(const shape_t* this) {return this->vt->perimeter(this);}
