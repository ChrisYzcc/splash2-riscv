# RISC-V Splash2 Benchmark

## Command
**Build Command**
```
Usage: ./build.sh [-p program] [-r] [-h] [-u usage]
  -p program   : specify the program to build. Default: barnes
  -r           : set platform to rv64
  -u           : set usage: normal, profiling, checkpoint. Default: normal
  -h           : display this help message
```

Example：

```bash
./build.sh -r -u checkpoint -p all
```
Building all workload in RISC-V version for generating checkpoints.

**Run Command**
```
Usage: ./run.sh [-p program] [-r] [-v version] [-h]
  -p program   : specify the program to run, default: barnes
  -r           : set platform to rv64
  -n threads   : specify the number of threads, default: 1
  -u usage     : set usage: normal, profiling, checkpoint. default: normal 
                     normal: normal execution; 
                     profiling: for profiling; 
                     checkpoint: for checkpointing.
  -h           : display this help message
```

**RISC-V Package**

`gen_rv_pack.sh` will pack all the RISC-V bins and datas with running scripts into `splash2_rv_pack`. You can simply copy that package to the target RISC-V machine.
```
Usage: ./gen_rv_pack.sh [-i inputs] [-u usage] [-h]
  -i inputs    : specify the inputs to package. Default: test
  -u usage     : set usage: normal, profiling, checkpoint. Default: normal
  -h           : display this help message
```

## Tests Summay
Native Platform: x86_64, Debian on WSL2

RISC-V Platfrom: QEMU, Kunminghu Config

| Test Name | Native Run    | RISC-V Run    |
| ----      | :----:        | :----:        |
| barnes    | *             | *             |
| cholesky  | *             | *             |
| fft       | *             | *             |
| fmm       | *             | *             |
| lu_cb     | *             | *             |
| lu_ncb    | *             | *             |
| ocean_cp  | *             | *             |
| ocean_ncp | *             | *             |
| radiosity | *             | *             |
| radix     | *             | *             |
| raytrace  | *             | *             |
| volrend   | *             | *             |
| water_ns  | *             | *             |
| water_sp  | *             | *             |

`raytrace` will cause segmentation fault on qemu-riscv machine. - Fix: fix multiple definition.

## Future Work
- [x] Fix `raytrace`.