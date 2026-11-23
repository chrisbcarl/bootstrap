# mpicc -showme to get the direct openmpi includes necessary
# https://stackoverflow.com/a/49083899
CC=/usr/local/cuda/bin/nvcc
CFLAGS= -I/usr/lib/x86_64-linux-gnu/openmpi/include -I/usr/lib/x86_64-linux-gnu/openmpi/include/openmpi -I/usr/local/cuda/include -Xcompiler -fopenmp
LDFLAGS= -L/usr/lib/x86_64-linux-gnu/openmpi/lib -L/usr/local/cuda/lib
LIB= -lgomp -lcudart -lmpi
SOURCES= hello-world.cu
EXECNAME= hello-world.exe
all:
	$(CC) -o $(EXECNAME) $(SOURCES) $(LIB) $(LDFLAGS) $(CFLAGS)
clean:
	rm *.o *.linkinfo