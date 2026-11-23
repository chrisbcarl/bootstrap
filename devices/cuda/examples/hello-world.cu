/*

On Windows, after installing NVIDIA CUDA Toolkit 13.2

```powershell
# https://www.nvidia.com/docs/IO/116711/sc11-cuda-c-basics.pdf

# add cl.exe to path
$env:PATH = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64;$($env:PATH)"

nvcc devices/cuda/examples/hello-world.cu `
    "-IC:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v13.2\include" `
    -o ./dist/hello-world

# should only need this, but if not
nvcc devices/cuda/examples/hello-world.cu `
    -o ./dist/hello-world

& ./dist/hello-world
```

*/
#include <stdio.h>
#include <cuda.h>

__global__ void mykernel() {}

int main(int argc, char** argv) {
    mykernel<<<1,1>>>();
    printf("Hello World!\n");
    return 0;
}
