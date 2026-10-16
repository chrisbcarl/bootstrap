/*
Perhaps the key insight is knowing that all pointers are same length,
    the compiler just tries to keep types in line.
    Not worth to pass types, pass voids. cast within the function.
*/

#include <stdio.h>
#include <stdlib.h>

#include <oop.h>
#include <vector_2d.h>

vector_2d_t* vector_2d_t_constructor(int x0, int x1) {
    vector_2d_t* this = malloc(sizeof(vector_2d_t));
    object_t* obj = construct((void*) this, vector_2d_t_destroy);

    this->_x0 = x0, this->_x1 = x1;
    this->get_x0 = vector_2d_t_get_x0;
    this->get_x1 = vector_2d_t_get_x1;
    this->set_x0 = vector_2d_t_set_x0;
    this->set_x1 = vector_2d_t_set_x1;
    this->print = vector_2d_t_print;
    this->mult = vector_2d_t_mult;

    printf("constructed vector_2d_t @ 0x%p\n", (void*)this);
    return this;  // you get back a vector, but an "object" is tracked globally.
}

int vector_2d_t_get_x0(void* this) {vector_2d_t* self = (vector_2d_t*)this; return self->_x0;}
int vector_2d_t_get_x1(void* this) {vector_2d_t* self = (vector_2d_t*)this; return self->_x1;}
void vector_2d_t_set_x0(void* this, int value) {vector_2d_t* self = (vector_2d_t*)this; self->_x0 = value;}
void vector_2d_t_set_x1(void* this, int value) {vector_2d_t* self = (vector_2d_t*)this; self->_x1 = value;}

void vector_2d_t_print(void* this) {
    vector_2d_t* self = (vector_2d_t*)this;
    printf("[[%d],\n [%d]]\n", self->_x0, self->_x1);
}

vector_2d_t* vector_2d_t_mult(void* this, void* other) {
    // dot product
    vector_2d_t* self = (vector_2d_t*)this;
    vector_2d_t* them = (vector_2d_t*)other;
    vector_2d_t* new = vector_2d_t_constructor(
        self->_x0 * them->_x0,
        self->_x1 * them->_x1
    );
    return new;
}

void vector_2d_t_destroy(void* this) {
    vector_2d_t* self = (vector_2d_t*) this;
    free(self);

    printf("        destroyed vector_2d_t @ 0x%p\n", this);
}
