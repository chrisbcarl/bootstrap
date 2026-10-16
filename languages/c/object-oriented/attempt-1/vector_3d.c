#include <stdio.h>

#include <oop.h>
#include <vector_2d.h>
#include <vector_3d.h>



vector_3d_t* vector_3d_t_constructor(int x0, int x1, int x2) {
    vector_3d_t* this = malloc(sizeof(vector_3d_t));
    object_t* obj = construct((void*) this, vector_3d_t_destroy);

    this->parent = vector_2d_t_constructor(x0, x1);

    this->_x2 = x2;
    this->get_x2 = vector_3d_t_get_x2;
    this->set_x2 = vector_3d_t_set_x2;
    this->print = vector_3d_t_print;
    this->mult = vector_3d_t_mult;

    printf("constructed vector_3d_t @ 0x%p\n", (void*)this);
    return this;
}
int vector_3d_t_get_x2(void* this) {vector_3d_t* self = (vector_3d_t*)this; return self->_x2;}
void vector_3d_t_set_x2(void* this, int value) {vector_3d_t* self = (vector_3d_t*)this; self->_x2 = value;}
void vector_3d_t_print(void* this) {
    vector_3d_t* self = (vector_3d_t*)this;
    printf("[[%d],\n [%d],\n [%d]]\n", super_property(self, _x0), super_property(self, _x1), self->_x2);
}
vector_3d_t* vector_3d_t_mult(void* this, void* other) {
    // dot product
    vector_3d_t* self = (vector_3d_t*)this;
    vector_3d_t* them = (vector_3d_t*)other;
    vector_3d_t* new = vector_3d_t_constructor(
        self->parent->_x0 * them->parent->_x0,
        self->parent->_x1 * them->parent->_x1,
        self->_x2 * them->_x2
    );
    return new;
}

void vector_3d_t_destroy(void* this) {
    vector_3d_t* self = (vector_3d_t*) this;
    // TODO: the only way the parent gets cleaned up is via the gc...
    // vector_2d_t_destroy(self->parent);
    free(self);

    printf("        destroyed vector_3d_t @ 0x%p\n", this);
}
