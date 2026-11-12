# Build validation — 2026-11-12

Validation used Ubuntu x86_64, GCC 13.3.0, `riscv64-linux-gnu-gcc` 13.3.0,
GNU binutils 2.42, and GNU Make 4.3.

## Original checkout

All 14 workloads compiled in native and RISC-V `normal` mode. All 14 native
programs also completed with the supplied test inputs and one thread.
`checkpoint` compilation stopped in the hooks library because its shared-library
Makefile required an unavailable `libtool` executable. The library is now built
as the static archive required by the statically linked benchmarks.

## Clean source build

Only repository source files and compressed test inputs were copied into an
empty temporary directory, without any existing objects, libraries, binaries,
or generated TIFF tables. The build entry point was invoked from outside that
directory.

| Platform | Mode | Workloads built | Native runs, 1 thread | Native runs, 2 threads |
| --- | --- | ---: | ---: | ---: |
| native | normal | 14/14 | 14/14 | 14/14 |
| native | checkpoint | 14/14 | 14/14 | 14/14 |
| native | profiling | 14/14 | 14/14 | 14/14 |
| rv64 | normal | 14/14 | — | — |
| rv64 | checkpoint | 14/14 | — | — |
| rv64 | profiling | 14/14 | — | — |

All 84 build outputs were produced successfully. The 42 RISC-V binaries were
checked with `readelf`: each is a static RISC-V ELF64 executable. Disassembly of
the RISC-V checkpoint/profiling hooks archives confirmed NEMU instructions.

All 84 native test runs exited successfully. Instrumented native runs also
printed the expected ROI entry, ROI exit, and termination messages. These are
execution checks using the supplied inputs, not a comprehensive numerical
correctness comparison.

RISC-V execution was not tested: this host has no `qemu-riscv64` executable, and
the instrumented modes require the matching NEMU environment. Successful
cross-compilation does not establish simulator runtime compatibility.

## Packaging and failure handling

- Packages for all three modes contained all 14 matching binaries, seven input
  archives, and the run scripts. The packaged runner was exercised with a native
  Barnes binary substituted temporarily; this checks script portability only.
- All seven `.tar.gz` inputs decompressed to exactly the original tracked tar
  bytes, preserving every dataset and archive member.
- Fourteen argument/failure checks covered compiler errors with an old installed
  binary present, hooks compiler errors, missing binaries, invalid arguments and
  thread counts, benchmark exit status propagation, and packaging failures that
  preserve an existing package.
- Every shell entry point passed `sh -n`; `git diff --check` passed.

## Repository cleanup

Removed the generated TIFF decoding table, its obsolete MIPS generator binary,
and an FMM timing output. The table and host generator are rebuilt from source.
Consolidated 14 benchmark build scripts into the top-level build entry point and
replaced the hooks Makefile variants with one static-library Makefile.

The input archives are compressed without removing data. Reference outputs,
original source data, legacy vendor source/configuration files, and license
notices are retained. Build and runtime products remain ignored by Git. This
changes the current checkout; existing Git history is preserved. Current source
and input content decreased from approximately 23.4 MiB to 7.5 MiB (68%).
