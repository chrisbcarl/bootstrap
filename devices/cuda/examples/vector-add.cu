/*
Description:
    On Windows, after installing NVIDIA CUDA Toolkit 13.2
    # https://www.nvidia.com/docs/IO/116711/sc11-cuda-c-basics.pdf
    TODO: synchronization and gating

Updates:
    2026-11-18 22:34 - everything works, i can breathe now.
    2026-11-18 22:23 - FIX: i feel inadequate as an engineer for not having self-understood what went wrong.
    2026-11-18 21:56 - WARNING: does not work on -N > 64... something is fundamentally wrong here
    2026-11-18 21:22 - tested on hardware that doesnt have cuda, we're good.
    2026-11-18 21:09 - done, works, and looks good
    2026-11-18 19:40 - getting into the grove now that mem copy makes sense
    2026-11-18 19:24 - initial commit

Run:
    ```powershell

    # add cl.exe to path
    $env:PATH = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64;$($env:PATH)"

    nvcc devices/cuda/examples/vector-add.cu `
        "-IC:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v13.2\include" `
        -o /devices/cuda/examples/vector-add

    # should only need this, but if not
    nvcc devices/cuda/examples/vector-add.cu `
        -o devices/cuda/examples/vector-add

    & devices/cuda/examples/vector-add
    ```

Learings:
    - Device pointers point to GPU memory
        - May be passed to/from host code
        - May not be dereferenced in host code
    - Host pointers point to CPU memory
        - May be passed to/from device code
        - May not be dereferenced in device code

    kernelfunc<<<N,M>>> - N is number of blocks to use, M is number of threads to use per block
        kernelfunc is only run once on that block/thread combo
        index into data with idx = blockIdx.x * threadIdx.x * blockDim.x;
            blockDim.x is device # threads / block

    block - each parallel invocation
    grid - sets of blocks
    blockIdx.x - invocation's block index
    threadIdx.x - invocation's thread index
    blockDim.x - device's threads per block

    threads:
        WITHIN A BLOCK, threads share data
        Declare using __shared__, allocated per block
*/
#include <stdio.h>
#include <cuda.h>
#include <cstring>  // c strcmp
#include <iostream>  // c++ stdio
#include <sstream>  // istringstream
#include <cstdlib>  // c - srand, rand
#include <random>  // c++ - mersenne twister, uniform
#include <list>  // c++ list
#include <chrono>

/* ******************** accelerator code ******************** */
__global__ void vector_add_block(int *c, int *a, int *b, size_t items) {
    /*
    N blocks to execute
    call via:           vector_add_block<<<N,1>>>(dev_u, dev_v, dev_w);
    means:              for (idx(block) in N) {c[idx] = a[idx] + b[idx];}
    If N is 1, then this loop is run ONCE on data index 0, the rest are ignored.
    */
    if (blockIdx.x < items) {
        c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
    }
}
__global__ void vector_add_thread(int *c, int *a, int *b, size_t items) {
    /*
    M threads to execute
    call via:           vector_add_thread<<<1,M>>>(dev_u, dev_v, dev_w);
    means:              for (idx(thread) in M) {c[idx] = a[idx] + b[idx];}
    If M is 1, then this loop is run ONCE on data index 0, the rest are ignored.
    */
    if (threadIdx.x < items) {
        c[threadIdx.x] = a[threadIdx.x] + b[threadIdx.x];
    }
}
__global__ void vector_add_block_thread(int *c, int *a, int *b, size_t items) {
    /*
    N blocks, M threads to execute
    call via:           vector_add_thread<<<N,M>>>(dev_u, dev_v, dev_w);
    means:              for (idx(block*threads-per-block + thread) in N,M ) {c[idx] = a[idx] + b[idx];}
    If N,M is 1, then this loop is run ONCE on data index 0, the rest are ignored.
    */
    int idx = threadIdx.x + blockDim.x * blockIdx.x;  // thread here is the offset
    if (idx < items) {
        c[idx] = a[idx] + b[idx];
    }
}

/* ******************** host code ******************** */
void print_vector(size_t count, int* vec) {
    printf("<");
    for (size_t i = 0; i < count - 1; i++) { printf("%d", vec[i]); }
    printf("%d>\n", vec[count-1]);
}
int64_t sum_vector(size_t count, int* vec) {
    int64_t acc = 0;
    for (size_t i = 0; i < count - 1; i++) { acc += vec[i]; }
    return acc;
}

// reminder that this is c++
template<typename T>
void vector_fill_random(size_t count, T* vec, T min, T max) {
    std::random_device rd;  // a seed source for the random number engine
    std::mt19937 gen(rd());  // mersenne_twister_engine seeded with rd()
    std::uniform_int_distribution<> dist(min, max);  // do not templatize
    for (size_t i = 0; i < count; i++) {
        vec[i] = rand() % (max - min + 1) + min;
        vec[i] = dist(gen);  // inclusive, dont templatize
    }
}

int cuda_inspect() {
    /* device inspect */
    int dev_count = 0;
    cudaError_t cuda_error = cudaGetDeviceCount(&dev_count);
    if (dev_count == 0) {
        std::cerr << "ERROR: No CUDA devices detected!" << std::endl;
        return 1;
    }
    if (cuda_error != cudaSuccess) {
        std::cerr << "ERROR: " << cuda_error << " - " << cudaGetErrorString(cuda_error) << std::endl;
        return 1;
    }
    printf("CUDA Detected: %d devices\n", dev_count);

    int dev_id;
    cudaDeviceProp prop;
    for (int i = 0; i < dev_count; i++) {
        cudaSetDevice(i);
        cudaGetDevice(&dev_id);
        std::cout << "Dev " << dev_id << std::endl;

        // https://developer.nvidia.com/blog/cuda-pro-tip-the-fast-way-to-query-device-properties/
        int smemSize, numProcs;
        auto start = std::chrono::high_resolution_clock::now();
        for (int i = 0; i < 100; ++i) {
            cudaDeviceGetAttribute(&smemSize, cudaDevAttrMaxSharedMemoryPerBlock, dev_id);
            cudaDeviceGetAttribute(&numProcs, cudaDevAttrMultiProcessorCount, dev_id);
        }
        auto end = std::chrono::high_resolution_clock::now();
        std::cout << "    cudaDeviceGetAttribute -> " << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 100.0 << "us" << std::endl;
        std::cout << "        MaxSharedMemoryPerBlock:      " << smemSize << std::endl;
        std::cout << "        MultiProcessorCount:          " << numProcs << std::endl;

        // https://docs.nvidia.com/cuda/cuda-runtime-api/cuda_runtime_api/structcudaDeviceProp.html
        start = std::chrono::high_resolution_clock::now();
        cuda_error = cudaGetDeviceProperties(&prop, dev_id);
        end = std::chrono::high_resolution_clock::now();
        if (cuda_error != cudaSuccess) {
            std::cerr << "ERROR: " << cuda_error << " - " << cudaGetErrorString(cuda_error) << std::endl;
            exit(1);
        }
        std::cout << "    cudaGetDeviceProperties -> " << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 100.0 << "us" << std::endl;
        std::cout << "        name:                         " << prop.name << std::endl;
        std::cout << "        memoryBusWidth (bits):        " << prop.memoryBusWidth << std::endl;
        std::cout << "        multiProcessorCount:          " << prop.multiProcessorCount << std::endl;
        std::cout << "        maxBlocksPerMultiProcessor:   " << prop.maxBlocksPerMultiProcessor << std::endl;
        std::cout << "        maxThreadsPerBlock:           " << prop.maxThreadsPerBlock << std::endl;
        std::cout << "        maxThreadsPerMultiProcessor:  " << prop.maxThreadsPerMultiProcessor << std::endl;
        std::cout << "        maxThreadsDim[0]:             " << prop.maxThreadsDim[0] << std::endl;
        std::cout << "        maxThreadsDim[1]:             " << prop.maxThreadsDim[1] << std::endl;
        std::cout << "        maxThreadsDim[2]:             " << prop.maxThreadsDim[2] << std::endl;
        std::cout << "        warpSize:                     " << prop.warpSize << std::endl;
    }
    return 0;
}

void cuda_error_exit(cudaError_t cuda_error) {
    if (cuda_error > 0) {
        const char* cu_error_str = cudaGetErrorString(cuda_error);
        fprintf(stderr, "ERRORS: %lu - %s\n", cuda_error, cu_error_str);
        exit(cuda_error);
    }
}

int main(int argc, char** argv) {
    /* program logic */
    srand(time(0));
    size_t N = 64;

    if (argc > 1) {
        if (argc == 3 && (strcmp(argv[1], "-N") == 0 || strcmp(argv[1], "-n") == 0)) {
            try
            {
                std::istringstream iss(argv[2]);
                iss >> N;
                if (N == 0) {
                    std::cerr << "ERROR: -N parse error!" << std::endl;
                    return 1;
                }
            }
            catch(const std::exception& e)
            {
                std::cerr << "ERROR: " << e.what() << std::endl;
                return 1;
            }
            printf("INFO: using -N %llu\n", N);
        } else {
            std::cout << "usage: vector-add [-h] [-n N]\n"
"\n"
"    How to use vector-add\n"
"\n"
"Examples:\n"
"    $ vector-add -n 64\n"
"    $ vector-add -n 128\n"
"    $ vector-add -n 1000000\n"
"    $ vector-add -n 1000000000\n"
"\n"
"options:\n"
"  -h, --help  show this help message and exit\n"
"\n"
"optional:\n"
"  -n N        N? (default: 64)\n";
            return 1;
        }
    }

    size_t bytes = N * sizeof(int);

    // dev check
    int rc = cuda_inspect();
    if (rc != EXIT_SUCCESS) { return rc; }

    // host alloc
    int* u = new int[N];
    int* v = (int*) calloc(N, sizeof(int));
    int* w = new int[N];

    std::cout << "CPU allocating -N " << N << std::endl;
    auto start = std::chrono::high_resolution_clock::now();
    vector_fill_random<int>(N, u, 0, 1);
    vector_fill_random<int>(N, v, 0, 1);
    auto end = std::chrono::high_resolution_clock::now();
    std::cout << "    -> " << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 100.0 << "us" << std::endl;
    if (N < 128 + 1) {
        printf("u: "); print_vector(N, u);
        printf("v: "); print_vector(N, v);
    } else {
        printf("\\sum u: %lld\n", sum_vector(N, u));
        printf("\\sum v: %lld\n", sum_vector(N, v));
    }

    // dev alloc
    std::cout << "GPU allocating -N " << N << std::endl;
    int *dev_u, *dev_v, *dev_w;  // device copies of a, b, c
    start = std::chrono::high_resolution_clock::now();
    cudaMalloc((void **)&dev_u, bytes);
    cudaMalloc((void **)&dev_v, bytes);
    cudaMalloc((void **)&dev_w, bytes);
    end = std::chrono::high_resolution_clock::now();
    std::cout << "    -> " << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 100.0 << "us" << std::endl;

    // host to dev
    std::cout << "CPU copy to GPU" << std::endl;
    start = std::chrono::high_resolution_clock::now();
    cudaMemcpy(dev_u, u, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(dev_v, v, bytes, cudaMemcpyHostToDevice);
    end = std::chrono::high_resolution_clock::now();
    std::cout << "    -> " << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 100.0 << "us" << std::endl;

    // https://docs.nvidia.com/cuda/cuda-programming-guide/02-basics/asynchronous-execution.html#asynchronous-execution
    // w = u + v
    std::cout << "w = u + v" << std::endl;
    start = std::chrono::high_resolution_clock::now();

    // vector_add_block<<<N,1>>>(dev_w, dev_u, dev_v, N);  // execute on N blocks, 1 thread--each gets one iteration of the logic
    // cudaDeviceSynchronize();  // all funcs async, return immediately, so wait for them to actually finish...

    // FAILS on -N > 1024
    // vector_add_thread<<<1,N>>>(dev_w, dev_u, dev_v, N);  // execute on 1 block, N threads--each gets one iteration of the logic
    // cudaDeviceSynchronize();  // all funcs async, return immediately, so wait for them to actually finish...

    // vector_add_block_thread<<<100,100>>>(dev_w, dev_u, dev_v, N);  // works even if wrongly allocated. allocated 100 threads across 100 blocks, only need 64 items
    // cudaDeviceSynchronize();  // all funcs async, return immediately, so wait for them to actually finish...

    // size_t M = 4;  // say I want 4 threads used per block, then I only need 8 blocks
    // vector_add_block_thread<<<N/M,M>>>(dev_w, dev_u, dev_v, N);  // execute on N/M blocks, M threads--each gets one iteration of the logic
    // cudaDeviceSynchronize();  // all funcs async, return immediately, so wait for them to actually finish...

    // CANONICAL INVOCATION
    // https://docs.nvidia.com/cuda/cuda-programming-guide/02-basics/intro-to-cuda-cpp.html#bounds-checking
    // use max threads per block
    int dev_id;
    cudaDeviceProp prop;
    cudaSetDevice(0);  // use first device, hardcode for now
    cudaGetDevice(&dev_id);
    cudaError_t cuda_error = cudaGetDeviceProperties(&prop, dev_id);
    cuda_error_exit(cuda_error);
    size_t T = prop.maxThreadsDim[0];  // threads_per_block
    size_t B = (N + T-1)/T;  // blocks needed, SM's will schedule how to deal with it
    if (B == 0) { B = 1; }
    vector_add_block_thread<<<B,T>>>(dev_w, dev_u, dev_v, N);
    // std::cout << "vector_add_block_thread<<<"<<B<<","<<T<<">>>(dev_w, dev_u, dev_v, "<<N<<");" << std::endl;
    // dev error handling
    cuda_error = cudaGetLastError();
    cuda_error_exit(cuda_error);
    cudaDeviceSynchronize();  // all funcs async, return immediately, so wait for them to actually finish...
    end = std::chrono::high_resolution_clock::now();
    std::cout << "    -> " << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 100.0 << "us" << std::endl;

    // dev to host
    std::cout << "GPU copy to CPU" << std::endl;
    start = std::chrono::high_resolution_clock::now();
    cudaMemcpy(w, dev_w, bytes, cudaMemcpyDeviceToHost);
    end = std::chrono::high_resolution_clock::now();
    std::cout << "    -> " << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 100.0 << "us" << std::endl;

    // host use
    if (N < 128 + 1) {
        printf("w: "); print_vector(N, w);
    } else {
        printf("\\sum w: %lld\n", sum_vector(N, w));
    }

    // dev free
    auto dev = std::list<int*>({dev_u, dev_v, dev_w});
    for (auto it = dev.begin(); it != dev.end(); it++) { cudaFree(*it); }

    // host free
    delete[] u; free(v); delete[] w;

    return 0;
}
