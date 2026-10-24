#!/bin/bash

trace="--trace=cuda,osrt"
output="report"
report="cuda_gpu_sum,cuda_api_sum,cuda_gpu_mem_size_sum"
timeunit="msec" # or nsec for nanosecond 

nvcc benchmark.cu saxpy.cu -o saxpy
nsys profile $trace --force-overwrite=true -o $output ./saxpy
nsys stats --timeunit $timeunit --force-export=true -r $report $output.nsys-rep