#include <stdlib.h>
#include <stdio.h>

#include <shape.h>
#include <shape-private.h>
#include <circle.h>

const shape_vt_t shape_vt_circle = {
    .class = "Circle",
    .destroy = circle_t_destroy,
    .get_x = shape_t_get_x,
    .set_x = shape_t_set_x,
    .get_y = shape_t_get_y,
    .set_y = shape_t_set_y,
    .print = circle_t_print,
    .area = circle_t_area,
    .perimeter = circle_t_perimeter,
};

struct circle_vt_t {
    double (*get_radius)(const shape_t*);
    void (*set_radius)(shape_t*, double);
};

const circle_vt_t circle_vt = {
    .get_radius = circle_t_get_radius,
    .set_radius = circle_t_set_radius,
};

struct circle_t {
    shape_t base;  // inheritance: is-a
    const circle_vt_t* vt;
    double r;  // inheritance: plus extra
};

shape_t* circle_t_construct(double x, double y, double radius) {
    circle_t* this = malloc(sizeof(circle_t));
    this->base = *shape_t_construct(&shape_vt_circle, x, y);
    this->vt = &circle_vt;
    this->r = radius;

    printf("created circle_t 0x%p\n", (void*) this);
    return (shape_t*)this;
}
circle_t* circle_t_from_shape(const shape_t* this) {return (circle_t*)circle_t_construct(this->x, this->y, 0.0);}
shape_t* shape_t_from_circle(const circle_t* this) {return shape_t_construct(&shape_vt_circle, this->base.x, this->base.y);}
void circle_t_destroy(shape_t* this) {
    circle_t* self = (circle_t*)this;
    free(self);  // since we are a shape AND MORE
    printf("destroyed circle_t 0x%p\n", (void*) this);
}

// methods
void circle_t_print(const shape_t* this) {
    circle_t* self = (circle_t*)this;
    printf("%s<%0.3f, %0.3f, %0.3f>\n", this->vt->class, this->x, this->y, self->r);
}
double circle_t_area(const shape_t* this) {
    circle_t* self = (circle_t*)this;
    return M_PI * self->r * self->r;
}
double circle_t_perimeter(const shape_t* this) {circle_t* self = (circle_t*)this; return 2 * M_PI * self->r;}
double circle_t_get_radius(const shape_t* this) {circle_t* self = (circle_t*)this; return self->r;}
void circle_t_set_radius(shape_t* this, double radius) {circle_t* self = (circle_t*)this; self->r = radius;}
