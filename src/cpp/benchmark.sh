#!/bin/bash

g++ -O3 -march=native ./*.cpp -o saxpy
./saxpy