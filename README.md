# RISC-V SPLASH-2 benchmarks

This repository builds 14 SPLASH-2 workloads for native Linux or RISC-V Linux:
`barnes`, `cholesky`, `fft`, `fmm`, `lu_cb`, `lu_ncb`, `ocean_cp`, `ocean_ncp`,
`radiosity`, `radix`, `raytrace`, `volrend`, `water_nsquared`, and `water_spatial`.

## Requirements

- A Linux host with a C compiler, GNU Make, GNU m4, binutils, tar, and gzip.
- The target's static C, math, and pthread libraries; binaries are linked statically.
- For RISC-V: the `riscv64-linux-gnu-` toolchain and RISC-V Linux development libraries.
  On Debian/Ubuntu, the cross-compilation packages are `gcc-riscv64-linux-gnu`,
  `binutils-riscv64-linux-gnu`, and `libc6-dev-riscv64-cross`.

The hooks library is built directly with the C compiler and archiver; libtool is
not required. `volrend` builds its bundled TIFF library and generates its decoding
tables with a **host** compiler, including when cross-compiling.

## Build

```sh
./build.sh -p all                         # native, normal mode
./build.sh -r -p all                      # RISC-V, normal mode
./build.sh -r -u checkpoint -p all        # RISC-V, NEMU checkpoint hooks
./build.sh -r -u profiling -p all         # RISC-V, NEMU profiling hooks
./build.sh -p barnes -u checkpoint        # native, PARSEC ROI/timing hooks
```

Defaults are `-p barnes` and `-u normal`; `-r` selects RISC-V. Use `-h` for help.
The top-level script handles all benchmark builds and can be invoked from any
working directory. Each selected program/mode is rebuilt from source, and a
build error causes a nonzero exit status immediately.

`CROSS_COMPILE` can override the RISC-V toolchain prefix, for example:

```sh
CROSS_COMPILE=/opt/riscv/bin/riscv64-linux-gnu- ./build.sh -r -p all
```

`CC`, `AR`, `RANLIB`, `HOSTCC`, and `MAKE` can also override individual tools.
`CFLAGS`, `PORTABILITY_FLAGS`, and `LDFLAGS` add flags to the defaults. Workload
sources use GNU89 C; the hooks library uses GNU99 C.

Build products are stored in `<program>/build/<native|rv64>/<mode>/` and ignored
by Git. Sources under `src/` are not modified by the build.

## Run

```sh
./run.sh -p barnes -n 2
./run.sh -p fft -n 2 -u checkpoint
./run.sh -r -p barnes -n 2               # on a RISC-V Linux machine
```

Build the selected platform and mode first. Defaults are `barnes`, one thread,
`native`, and `normal`. Thread-count restrictions depend on the workload (many
require powers of two). Runtime errors are returned to the caller.

Test inputs are stored as `inputs/input_test.tar.gz` with their original contents
preserved. Run scripts extract them into `<program>/build/<platform>/run/` and
replace that directory's previous run files on each invocation.

RISC-V `checkpoint` and `profiling` binaries contain custom NEMU instructions.
Run them in the matching simulator environment. Native builds of these modes use
the PARSEC ROI and timing hooks without NEMU instructions.

## Package for RISC-V

```sh
./build.sh -r -p all -u normal
./gen_rv_pack.sh -u normal
```

Copy `splash2_rv_pack/` to the target machine, then run, for example:

```sh
cd splash2_rv_pack
./run.sh -r -p barnes -n 2 -u normal
```

The package includes the selected mode's binaries, compressed test inputs, and
run scripts. The packaging script checks all required files before replacing an
existing package. `-i test` is the only supported input set.

## Cleanup and validation

All generated builds and packages can be removed with:

```sh
rm -rf -- */build/ splash2_rv_pack/
```

Generated TIFF tables, the obsolete MIPS table-generator executable, and FMM
runtime timing output are not source files and are no longer tracked. Reference
outputs (`correct.out`), original source data, and third-party license notices
are retained.

See [BUILD_VALIDATION.md](BUILD_VALIDATION.md) for the verified build matrix and
runtime coverage.
