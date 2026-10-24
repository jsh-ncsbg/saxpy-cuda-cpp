#include "saxpy.hpp"

void saxpy(const size_t n, const float a, float *const __restrict__ out,
           const float *const __restrict__ x,
           const float *const __restrict__ y) {

    for (size_t i = 0; i < n; i++) {
        out[i] = a * x[i] + y[i];
    }
}
