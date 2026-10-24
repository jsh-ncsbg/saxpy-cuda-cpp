#include <algorithm>
#include <cstdlib>
#include <iostream>

#include "saxpy.cuh"

int max_diff(const size_t n, const int *const a, const int *const b) {
    int res = 0;
    for (size_t i = 0; i < n; i++) {
        res = std::max(res, std::abs(a[i] - b[i]));
    }
    return res;
}

int main(void) {
    const int N = 1 << 28;
    const int iterations = 20;

    std::cout << "arr_sz=" << N << "\n";

    const int a = 6;
    int *x, *y, *out, *expected_out;
    x = new int[N];
    y = new int[N];
    out = new int[N];
    expected_out = new int[N];

    int *d_x, *d_y, *d_out;
    cudaMalloc(&d_x, N * sizeof(int));
    cudaMalloc(&d_y, N * sizeof(int));
    cudaMalloc(&d_out, N * sizeof(int));

    // initialize x and y
    for (size_t i = 0; i < N; i++) {
        x[i] = 10;
        y[i] = 12;
        expected_out[i] = a * x[i] + y[i];
    }

    cudaMemcpy(d_x, x, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_y, y, N * sizeof(int), cudaMemcpyHostToDevice);

    const int numThreads = 256;
    const int numBlocks = 256;

    // run kernel
    for (size_t i = 0; i < iterations; i++) {
        saxpy<<<numBlocks, numThreads>>>(N, a, d_out, d_x, d_y);

        // wait for gpu
        cudaError_t err = cudaDeviceSynchronize();
        if (err != cudaSuccess) {
            std::cerr << cudaGetErrorString(err) << '\n';
        }
    }

    // verify output
    cudaMemcpy(out, d_out, N * sizeof(int), cudaMemcpyDeviceToHost);
    int mx_err = max_diff(N, out, expected_out);
    std::cout << "mx_err=" << mx_err << std::endl;

    // cleanup
    delete[] x;
    delete[] y;
    delete[] out;
    delete[] expected_out;

    cudaFree(d_x);
    cudaFree(d_y);
    cudaFree(d_out);

    return mx_err == 0 ? 0 : 1;
}
