#include <algorithm>
#include <cstdlib>
#include <iostream>

#include "saxpy.hpp"

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

    // initialize x and y
    for (size_t i = 0; i < N; i++) {
        x[i] = 10;
        y[i] = 12;
        expected_out[i] = a * x[i] + y[i];
    }

    // run kernel
    for (size_t i = 0; i < iterations; i++) {
        saxpy(N, a, out, x, y);
    }

    // verify output
    int mx_err = max_diff(N, out, expected_out);
    std::cout << "mx_err=" << mx_err << std::endl;

    delete[] x;
    delete[] y;
    delete[] out;
    delete[] expected_out;

    return mx_err == 0 ? 0 : 1;
}
