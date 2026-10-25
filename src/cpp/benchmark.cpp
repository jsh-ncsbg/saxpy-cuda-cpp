#include <algorithm>
#include <array>
#include <chrono>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <numeric>

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

    std::fill(out, out + N, 0);

    // initialize x and y
    for (size_t i = 0; i < N; i++) {
        x[i] = 10.0f;
        y[i] = 12.0f;
        expected_out[i] = a * x[i] + y[i];
    }

    std::array<double, iterations> elapsed_ms;
    for (size_t i = 0; i < iterations; i++) {
        const auto start = std::chrono::steady_clock::now();
        saxpy(N, a, out, x, y);
        const auto end = std::chrono::steady_clock::now();
        elapsed_ms[i] =
            std::chrono::duration<double, std::milli>(end - start).count();
    }

    const auto min_max =
        std::minmax_element(elapsed_ms.begin(), elapsed_ms.end());
    const double avg_ms =
        std::accumulate(elapsed_ms.begin(), elapsed_ms.end(), 0.0) / iterations;

    std::cout << std::fixed << std::setprecision(6)
              << "iterations=" << iterations << '\n'
              << "min_ms=" << *min_max.first << '\n'
              << "max_ms=" << *min_max.second << '\n'
              << "avg_ms=" << avg_ms << '\n'
              << std::defaultfloat;

    // verify output
    float mx_err = max_diff(N, out, expected_out);
    std::cout << "mx_err=" << mx_err << std::endl;

    delete[] x;
    delete[] y;
    delete[] out;
    delete[] expected_out;

    return mx_err == 0.0f ? 0 : 1;
}
