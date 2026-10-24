#pragma once

#include <stdio.h>

void saxpy(const size_t n, const float a, float *__restrict__ out,
           const float *__restrict__ x, const float *__restrict__ y);
