#include <algorithm>
#include <cmath>
#include <iostream>

#include "saxpy.hpp"

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

    // initialize x and y
    for (size_t i = 0; i < N; i++) {
        x[i] = 10.0f;
        y[i] = 12.0f;
        expected_out[i] = a * x[i] + y[i];
    }

    // run kernel
    for (size_t i = 0; i < iterations; i++) {
        saxpy(N, a, out, x, y);
    }

    // verify output
    float mx_err = max_diff(N, out, expected_out);
    std::cout << "mx_err=" << mx_err << std::endl;

    delete[] x;
    delete[] y;
    delete[] out;
    delete[] expected_out;

    return mx_err == 0.0f ? 0 : 1;
}
