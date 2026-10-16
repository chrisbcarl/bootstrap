/*
gcc languages/c/object-oriented/object-oriented-c.c \
    -Ilanguages/c/object-oriented \
    languages/c/object-oriented/oop.c \
    languages/c/object-oriented/vector_2d.c \
    languages/c/object-oriented/vector_3d.c \
    -o dist/object-oriented-c && dist/object-oriented-c

Needs PIE in reverse order: encapsulation, inheritance, and polymorphism...
- encapsulation
    - data and behavior
    - data-hiding (public/private)
- inheritance
    - code re-use
- polymorphism
    - behavior grafting at runtime...

Doable in gnu 8+, check with gcc --version
All macros and void pointers in my hack...

TODO:
    Virtual Table: a static struct object of the functions
        given to every new object who has a vtable pointer
        (rather than each object gets a pointer to the functions)

Apparently the gpt answer is:
    - datahiding
        - shape.h
            typedef struct Shape Shape;
        - shape.c
            struct Shape {int x; int y;} -> this is now hidden
    - inheritance
        - circle.c struct Circle {Shape base; int r;}
    - polymorphism
        - shape.c
            struct ShapeVT {void (*area)};
            struct Shape {ShapeVT vt; int x; int y;}
        - circle.c
            static ShapeVT circle_vt {circle_area};
            circle* constructor() {c->base.vt = circle_vt }

There is no way to do method(v0, func), basically v0.func().
    The only way to do things is
        class_method(cons class* obj)
            which deals with the inheritance chain as need be
        vtables (polymorphism) since shapes and animals all do the same thing, just differetly
            they share the same vtable definition but not the same vtable values
        data hiding through incomplete types in headers
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <oop.h>
#include <vector_2d.h>
#include <vector_3d.h>


int main(void) {
    oop_enable();

    vector_2d_t* v0 = vector_2d_t_constructor(1, 2);
    member(v0, print);  // encapsulation: data and behavior

    // property(v0, _x0) = 69;  // encapsulation: data-hiding
    vector_2d_t* v1 = vector_2d_t_constructor(3, 4);

    int v0x0 = member(v0, get_x0);
    printf("pre  v0.x0 = %d\n", v0x0);

    member(v0, set_x0, 69);
    v0x0 = member(v0, get_x0);
    printf("post v0.x0 = %d\n", v0x0);

    vector_2d_t* v2 = member(v0, mult, v1);

    member(v0, print);
    member(v1, print);
    member(v2, print);

    vector_3d_t* v4 = vector_3d_t_constructor(1, 2, 3);
    vector_3d_t* v5 = vector_3d_t_constructor(4, 5, 6);
    vector_3d_t* v6 = member(v4, mult, v5);
    member(v4, print);
    int v4_x0 = super_member(v4, get_x0);
    printf("pre  v4.x0 = %d\n", v0x0);
    super_member(v4, set_x0, 69);
    printf("post v4.x0 = %d\n", v0x0);


    // TODO: with this current architecture you cannot actually destroy objects explicitly
    //  they're handled by gc... gotta figure out a way to destroy objects directly.
    // destroy(v0);
    // destroy(v1);
    // destroy(v2);

    return 0;
}