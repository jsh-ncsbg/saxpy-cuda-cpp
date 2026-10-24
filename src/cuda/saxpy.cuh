#pragma once

__global__ void saxpy(const size_t n, const int a, int *sum, const int *x,
                      const int *y);
