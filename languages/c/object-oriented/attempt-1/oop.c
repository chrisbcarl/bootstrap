#include <stdio.h>
#include <oop.h>

char BUFFER[256] = {0};
void* OBJECTS[256] = {0};
// void* OBJECT_CLASS[256] = {0};  // TODO: would be nice to have an class map
//      TODO: map class ptrs to their obj wrappers so we can destroy them out of turn
//      TODO: simple sll hashtable would do nicely, map class ptr to obj ptr
uint8_t OBJECT_COUNT = 0;

object_t* construct(void* obj, void* object_destructor) {
    object_t* this = malloc(sizeof(object_t));
    this->_destructor = object_destructor;
    this->_id = OBJECT_COUNT;
    this->_obj = obj;

    OBJECTS[this->_id] = this;
    OBJECT_COUNT += 1;
    return this;
}

void destroy(void* this) {
    object_t* self = (object_t*) this;
    self->_destructor(self->_obj);  // kill the extra data

    size_t id = self->_id;
    free(self);  // kill the object wrapper
    OBJECTS[id] = NULL;
}

void garbage_collect() {
    printf("garbage collection, OBJECT_COUNT: %d\n", OBJECT_COUNT);

    for (size_t i = 0; i < OBJECT_COUNT; i++) {
        if (OBJECTS[i] != NULL) {
            printf("    destroy obj %lu @ 0x%p\n", i, OBJECTS[i]);
            destroy(OBJECTS[i]);
        }
    }
}

void oop_enable() {
    atexit(garbage_collect);
}
