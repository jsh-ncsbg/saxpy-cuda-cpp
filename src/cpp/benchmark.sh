#!/bin/bash

g++ -O3 -march=native -pg ./*.cpp -o saxpy
./saxpy
gprof -b -p ./saxpy gmon.out