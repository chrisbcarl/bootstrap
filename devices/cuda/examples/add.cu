/*

On Windows, after installing NVIDIA CUDA Toolkit 13.2

```powershell
# https://www.nvidia.com/docs/IO/116711/sc11-cuda-c-basics.pdf

# add cl.exe to path
$env:PATH = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64;$($env:PATH)"

nvcc devices/cuda/examples/add.cu `
    "-IC:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v13.2\include" `
    -o ./dist/add

# should only need this, but if not
nvcc devices/cuda/examples/add.cu `
    -o ./dist/add

& ./dist/add
```

- Device pointers point to GPU memory
    - May be passed to/from host code
    - May not be dereferenced in host code
- Host pointers point to CPU memory
    - May be passed to/from device code
    - May not be dereferenced in device code

*/
#include <stdio.h>
#include <cuda.h>

__global__ void add(int *a, int *b, int *c) {
    *c = *a + *b;
}

int main(int argc, char** argv) {
    int a=2, b=7, c=-1;  // host copies of a, b, c
    int *d_a, *d_b, *d_c;  // device copies of a, b, c
    int size = sizeof(int);

    // Allocate space for device copies of a, b, c
    cudaMalloc((void **)&d_a, size);
    cudaMalloc((void **)&d_b, size);
    cudaMalloc((void **)&d_c, size);

    // Copy inputs to device
    cudaMemcpy(d_a, &a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, &b, size, cudaMemcpyHostToDevice);

    add<<<1,1>>>(d_a, d_b, d_c);  // execute add 1 times in parallel

    cudaMemcpy(&c, d_c, size, cudaMemcpyDeviceToHost);  // Copy result back to host

    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);  // Cleanup

    printf("c: %d\n", c);
    return 0;
}
