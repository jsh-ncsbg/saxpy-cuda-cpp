# saxpy-cuda

A comparison of integer SAXPY implementations in C++ and CUDA.

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
      <td align="right">6.00</td>
      <td align="right">33.55</td>
      <td align="right">0.5252</td>
      <td align="right">0.8963</td>
      <td align="right">0.5543</td>
      <td align="right">363.21</td>
      <td align="right">10.82x</td>
    </tr>
    <tr>
      <td>2^26</td>
      <td align="right">25.50</td>
      <td align="right">31.58</td>
      <td align="right">2.1037</td>
      <td align="right">2.4895</td>
      <td align="right">2.1805</td>
      <td align="right">369.32</td>
      <td align="right">11.69x</td>
    </tr>
    <tr>
      <td>2^28</td>
      <td align="right">104.50</td>
      <td align="right">30.83</td>
      <td align="right">8.4888</td>
      <td align="right">9.6282</td>
      <td align="right">8.8029</td>
      <td align="right">365.93</td>
      <td align="right">11.87x</td>
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
