#ifndef H_VECTOR_3D
#define H_VECTOR_3D

#include <oop.h>

typedef struct vector_3d_t {
    struct vector_2d_t* parent;
    int _x2;
    int (*get_x2)(void*);
    void (*set_x2)(void*, int);
    void (*print)(void*);
    struct vector_3d_t* (*mult)(void*, void*);
} vector_3d_t;


vector_3d_t* vector_3d_t_constructor(int x0, int x1, int x2);
int vector_3d_t_get_x2(void* this);
void vector_3d_t_set_x2(void* this, int value);
void vector_3d_t_print(void* this);
vector_3d_t* vector_3d_t_mult(void* this, void* other);
void vector_3d_t_destroy(void* this);


#endif
