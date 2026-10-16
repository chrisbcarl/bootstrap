#ifndef H_OOP
#define H_OOP

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

typedef struct object_t {
    void (*_destructor)(void*);
    size_t _id;
    void* _obj;  // the "rest of it"
} object_t;

object_t* construct(void* obj, void* object_destructor);
void destroy(void* obj);

extern char BUFFER[256];
extern void* OBJECTS[256];
extern uint8_t OBJECT_COUNT;

// https://gcc.gnu.org/onlinedocs/cpp/Variadic-Macros.html
// https://gcc.gnu.org/onlinedocs/cpp/Stringizing.html
#define die(str) \
    strcpy(BUFFER, str); \
    fputs(BUFFER, stderr); \
    exit(1);

#define property(obj, attr) \
    strcpy(BUFFER, #attr); \
    if (BUFFER[0] == '_') { die("cannot invoke private property '" #attr "'\n") } \
    obj->attr

// __VA_OPT__ available in gcc 8+
#define member(obj, func, ...) \
    obj->func(obj __VA_OPT__(,) __VA_ARGS__); \
    strcpy(BUFFER, #func); \
    if (BUFFER[0] == '_') { die("cannot invoke private member '" #func "'\n") }

#define super_property(obj, attr) obj->parent->attr
#define super_member(obj, func, ...) obj->parent->func(obj->parent __VA_OPT__(,) __VA_ARGS__)

void garbage_collect();
void oop_enable();

#endif
