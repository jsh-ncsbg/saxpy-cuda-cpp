# saxpy-cuda

A comparison of SAXPY implementations in C++ and CUDA.

SAXPY is defined as:

$$
\mathrm{saxpy}_i = a x_i + y_i, \qquad 0 \le i < N
$$

## Results

C++ execution times were recorded using `gprof`, while CUDA kernel times were obtained using `nsys stats`. Each input size was run for 20 iterations.

<table align="center">
  <thead>
    <tr>
      <th rowspan="2" scope="col">N</th>
      <th colspan="2" scope="colgroup">C++</th>
      <th colspan="4" scope="colgroup">CUDA</th>
      <th rowspan="2" scope="col">Speedup</th>
    </tr>
    <tr>
      <th scope="col">Avg (ms)</th>
      <th scope="col">GB/s</th>
      <th scope="col">Min (ms)</th>
      <th scope="col">Max (ms)</th>
      <th scope="col">Avg (ms)</th>
      <th scope="col">GB/s</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>2^24</td>
      <td align="right">6.50</td>
      <td align="right">30.97</td>
      <td align="right">0.5267</td>
      <td align="right">0.8618</td>
      <td align="right">0.5554</td>
      <td align="right">362.49</td>
      <td align="right">11.70x</td>
    </tr>
    <tr>
      <td>2^26</td>
      <td align="right">27.00</td>
      <td align="right">29.83</td>
      <td align="right">2.1402</td>
      <td align="right">2.4918</td>
      <td align="right">2.1931</td>
      <td align="right">367.20</td>
      <td align="right">12.31x</td>
    </tr>
    <tr>
      <td>2^28</td>
      <td align="right">113.50</td>
      <td align="right">28.38</td>
      <td align="right">8.4455</td>
      <td align="right">9.1478</td>
      <td align="right">8.6284</td>
      <td align="right">373.33</td>
      <td align="right">13.15x</td>
    </tr>
    <tr>
      <td>2^29</td>
      <td align="right">228.50</td>
      <td align="right">28.19</td>
      <td align="right">17.1380</td>
      <td align="right">17.7690</td>
      <td align="right">17.3662</td>
      <td align="right">370.98</td>
      <td align="right">13.16x</td>
    </tr>
  </tbody>
</table>

The C++ implementation was compiled with `-O3` and `-march=native`. CUDA used 256 blocks with 256 threads per block. In local tests, performance gains plateaued as the number of blocks and threads per block was increased.

## Running locally

The scripts use Bash. You'll need these installed and available on your `PATH`:

- C++: `g++` and `gprof`.
- CUDA: the CUDA Toolkit (`nvcc`) and Nsight Systems (`nsys`).

For CUDA, you'll also need an NVIDIA GPU with a compatible driver.

From the repository root, run either version:

```bash
(cd src/cpp && bash benchmark.sh)
(cd src/cuda && bash benchmark.sh)
```

Each script builds the program, runs it, and prints the profiler results. `mx_err=0` means the output matches the expected values.

`N` is hard-coded to `1 << 28`. To try another size, change it in `src/cpp/benchmark.cpp` or `src/cuda/benchmark.cu` and rerun the corresponding script.

## References

- [An Even Easier Introduction to CUDA (Updated)](https://developer.nvidia.com/blog/even-easier-introduction-cuda/)
- [Six Ways to SAXPY](https://developer.nvidia.com/blog/six-ways-saxpy/)
- [Introduction to the CUDA Programming Language, Lecture 4 (PDF)](https://users.wfu.edu/choss/CUDA/docs/Lecture%204.pdf)
