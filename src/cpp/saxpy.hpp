#pragma once

#include <stdio.h>

void saxpy(const size_t n, const int a, int *__restrict__ out,
           const int *__restrict__ x, const int *__restrict__ y);
