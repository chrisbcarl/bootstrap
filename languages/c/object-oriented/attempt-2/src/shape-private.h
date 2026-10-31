/*
Encapsulation:
    - Data and Behavior:
        - Data Hiding:
            - shape_t is defined in "./src", which is all private ONCE COMPILED
            - all other .c files will include this header, but their headers will not include this header
            - shape_t definition is here.
- Inheritance:
    - all shapes will include shape_t as a base member
- Polymorphism:
    - poly: all shapes get a virtual table of functions through the base
    - morphing: this table can be overwritten at runtime through the constructors
    - the table is implemented in private as well
*/

#ifndef H_SHAPE_PRIVATE
#define H_SHAPE_PRIVATE

#include <shape.h>

typedef struct shape_vt_t {
    const char* class;
    // defined
    double (*get_x)(const shape_t*);
    void (*set_x)(shape_t*, double);
    double (*get_y)(const shape_t*);
    void (*set_y)(shape_t*, double);
    // virtual
    double (*area)(const shape_t*);
    double (*perimeter)(const shape_t*);
    // virtual default
    void (*print)(const shape_t*);
    void (*destroy)(shape_t*);
} shape_vt_t;  // polymorphism (since any derived class can assign different functions to the table)

extern const shape_vt_t shape_vt;  // to be implemented in shape-private.c but visible in square/circle.c

// data hiding (since this file )
struct shape_t {
    const shape_vt_t* vt;
    double x;
    double y;
};

#endif
