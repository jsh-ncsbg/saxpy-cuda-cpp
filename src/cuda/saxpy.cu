#include "saxpy.cuh"

__global__ void saxpy(const size_t n, const int a, int *const sum,
                      const int *const x, const int *const y) {
    const size_t index = blockIdx.x * blockDim.x + threadIdx.x;
    const size_t stride = blockDim.x * gridDim.x;

    for (size_t i = index; i < n; i += stride) {
        sum[i] = a * x[i] + y[i];
    }
}
