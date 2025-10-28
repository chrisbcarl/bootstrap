# https://stackoverflow.com/a/51396583
man g++ | col -b | grep -B 2 -e '-std=.* This is the default'
#     GNU dialect of -std=c++17.  This is the default for C++ code.  The name gnu++1z is deprecated.

mkdir ./dist

# compile - basic compilation
g++ ./languages/c++/timing.cpp -o dist/main && dist/main


# compile - classes and header files and a main file
g++ ./languages/c++/class-main.cpp ./languages/c++/class.cpp "-I./languages/c++" -o dist/main && dist/main

