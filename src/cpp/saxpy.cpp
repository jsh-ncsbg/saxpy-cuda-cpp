#include "saxpy.hpp"

void saxpy(const size_t n, const int a, int *const __restrict__ out,
           const int *const __restrict__ x, const int *const __restrict__ y) {

    for (size_t i = 0; i < n; i++) {
        out[i] = a * x[i] + y[i];
    }
}
