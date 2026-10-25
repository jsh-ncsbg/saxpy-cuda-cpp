# saxpy-cuda

A comparison of SAXPY implementations in C++ and CUDA.

SAXPY is defined as:

$$
\mathrm{saxpy}_i = a x_i + y_i, \qquad 0 \le i < N
$$

## Results

C++ execution times are measured using `std::chrono::steady_clock`, while CUDA kernel times are obtained using `nsys stats`. Each input size is run for 20 iterations.

### C++

The C++ implementation was compiled with `-O3` and `-march=native`.

<table align="center">
  <thead>
    <tr>
      <th scope="col">N</th>
      <th scope="col">Min (ms)</th>
      <th scope="col">Max (ms)</th>
      <th scope="col">Avg (ms)</th>
      <th scope="col">GB/s</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>2^24</td>
      <td align="right">4.3659</td>
      <td align="right">5.5394</td>
      <td align="right">4.5244</td>
      <td align="right">44.50</td>
    </tr>
    <tr>
      <td>2^26</td>
      <td align="right">18.3375</td>
      <td align="right">19.1574</td>
      <td align="right">18.6802</td>
      <td align="right">43.11</td>
    </tr>
    <tr>
      <td>2^28</td>
      <td align="right">74.1643</td>
      <td align="right">76.7411</td>
      <td align="right">75.3874</td>
      <td align="right">42.73</td>
    </tr>
    <tr>
      <td>2^29</td>
      <td align="right">150.1940</td>
      <td align="right">156.0003</td>
      <td align="right">152.1992</td>
      <td align="right">42.33</td>
    </tr>
  </tbody>
</table>

### CUDA

CUDA used 256 blocks with 256 threads per block. In local tests, performance gains plateaued as the number of blocks and threads per block was increased.

<table align="center">
  <thead>
    <tr>
      <th scope="col">N</th>
      <th scope="col">Min (ms)</th>
      <th scope="col">Max (ms)</th>
      <th scope="col">Avg (ms)</th>
      <th scope="col">GB/s</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>2^24</td>
      <td align="right">0.5267</td>
      <td align="right">0.8618</td>
      <td align="right">0.5554</td>
      <td align="right">362.49</td>
    </tr>
    <tr>
      <td>2^26</td>
      <td align="right">2.1402</td>
      <td align="right">2.4918</td>
      <td align="right">2.1931</td>
      <td align="right">367.20</td>
    </tr>
    <tr>
      <td>2^28</td>
      <td align="right">8.4455</td>
      <td align="right">9.1478</td>
      <td align="right">8.6284</td>
      <td align="right">373.33</td>
    </tr>
    <tr>
      <td>2^29</td>
      <td align="right">17.1380</td>
      <td align="right">17.7690</td>
      <td align="right">17.3662</td>
      <td align="right">370.98</td>
    </tr>
  </tbody>
</table>

### C++ vs CUDA

<table align="center">
  <thead>
    <tr>
      <th scope="col">N</th>
      <th scope="col">C++ Avg (ms)</th>
      <th scope="col">CUDA Avg (ms)</th>
      <th scope="col">Speedup</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>2^24</td>
      <td align="right">4.5244</td>
      <td align="right">0.5554</td>
      <td align="right">8.15x</td>
    </tr>
    <tr>
      <td>2^26</td>
      <td align="right">18.6802</td>
      <td align="right">2.1931</td>
      <td align="right">8.52x</td>
    </tr>
    <tr>
      <td>2^28</td>
      <td align="right">75.3874</td>
      <td align="right">8.6284</td>
      <td align="right">8.74x</td>
    </tr>
    <tr>
      <td>2^29</td>
      <td align="right">152.1992</td>
      <td align="right">17.3662</td>
      <td align="right">8.76x</td>
    </tr>
  </tbody>
</table>

## Running locally

The scripts use Bash. You'll need these installed and available on your `PATH`:

- C++: `g++`.
- CUDA: the CUDA Toolkit (`nvcc`) and Nsight Systems (`nsys`).

For CUDA, you'll also need an NVIDIA GPU with a compatible driver.

From the repository root, run either version:

```bash
(cd src/cpp && bash benchmark.sh)
(cd src/cuda && bash benchmark.sh)
```

Each script builds the program, runs it, and prints the results. `mx_err=0` means the output matches the expected values.

`N` is hard-coded to `1 << 28`. To try another size, change it in `src/cpp/benchmark.cpp` or `src/cuda/benchmark.cu` and rerun the corresponding script.

## References

- [An Even Easier Introduction to CUDA (Updated)](https://developer.nvidia.com/blog/even-easier-introduction-cuda/)
- [Six Ways to SAXPY](https://developer.nvidia.com/blog/six-ways-saxpy/)
- [Introduction to the CUDA Programming Language, Lecture 4 (PDF)](https://users.wfu.edu/choss/CUDA/docs/Lecture%204.pdf)
