# https://stackoverflow.com/a/51396583
man g++ | col -b | grep -B 2 -e '-std=.* This is the default'
#     GNU dialect of -std=c++17.  This is the default for C++ code.  The name gnu++1z is deprecated.
