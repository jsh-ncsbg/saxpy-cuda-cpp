#pragma once

__global__ void saxpy(const size_t n, const float a, float *sum, const float *x,
                      const float *y);
