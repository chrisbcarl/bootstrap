// kernel.cu
//
// An arbitrary kernel
#ifndef _BURN_KERNEL_H_
#define _BURN_KERNEL_H_
__global__ void custy_kernel() {
    __shared__ float shared[512];
    float a = 3.0 * 5.0;
    float b = (a * 50) / 4;
    int pos = threadIdx.y*blockDim.x+threadIdx.x;
    shared[pos] = b;
}
#endif