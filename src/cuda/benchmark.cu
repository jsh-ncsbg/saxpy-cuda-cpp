#include <algorithm>
#include <cmath>
#include <iostream>

#include "saxpy.cuh"

float max_diff(const size_t n, const float *const a, const float *const b) {
    float res = 0.0f;
    for (size_t i = 0; i < n; i++) {
        res = std::max(res, std::fabs(a[i] - b[i]));
    }
    return res;
}

int main(void) {
    const int N = 1 << 28;
    const int iterations = 20;

    std::cout << "arr_sz=" << N << "\n";

    const float a = 6.7f;
    float *x, *y, *out, *expected_out;
    x = new float[N];
    y = new float[N];
    out = new float[N];
    expected_out = new float[N];

    float *d_x, *d_y, *d_out;
    cudaMalloc(&d_x, N * sizeof(float));
    cudaMalloc(&d_y, N * sizeof(float));
    cudaMalloc(&d_out, N * sizeof(float));

    // initialize x and y
    for (size_t i = 0; i < N; i++) {
        x[i] = 10.0f;
        y[i] = 12.0f;
        expected_out[i] = a * x[i] + y[i];
    }

    cudaMemcpy(d_x, x, N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_y, y, N * sizeof(float), cudaMemcpyHostToDevice);

    const int numThreads = 256;
    const int numBlocks = (N + numThreads - 1) / numThreads;

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
    cudaMemcpy(out, d_out, N * sizeof(float), cudaMemcpyDeviceToHost);
    float mx_err = max_diff(N, out, expected_out);
    std::cout << "mx_err=" << mx_err << std::endl;

    // cleanup
    delete[] x;
    delete[] y;
    delete[] out;
    delete[] expected_out;

    cudaFree(d_x);
    cudaFree(d_y);
    cudaFree(d_out);

    return mx_err == 0.0f ? 0 : 1;
}
