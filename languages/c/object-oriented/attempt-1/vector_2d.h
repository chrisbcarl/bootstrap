#ifndef H_VECTOR_2D
#define H_VECTOR_2D

#include <oop.h>

typedef struct vector_2d_t {
    int _x0, _x1;
    void (*print)(void*);
    int (*get_x0)(void*);
    int (*get_x1)(void*);
    void (*set_x0)(void*, int);
    void (*set_x1)(void*, int);
    struct vector_2d_t* (*mult)(void*, void*);
} vector_2d_t;

vector_2d_t* vector_2d_t_constructor(int x0, int x1);
int vector_2d_t_get_x0(void* this);
int vector_2d_t_get_x1(void* this);
void vector_2d_t_set_x0(void* this, int value);
void vector_2d_t_set_x1(void* this, int value);
void vector_2d_t_print(void* this);
vector_2d_t* vector_2d_t_mult(void* this, void* other);
void vector_2d_t_destroy(void* this);

#endif
