# rust-results — the pure-Rust port, built and run with cargo

What the **Rust** implementation does on the same machine, in the same
session, over the same 199 variants.

## Provenance

| item | value |
|---|---|
| generated | `2026-08-11T00:42:40Z` |
| repository commit | `f0d1c3d` |
| operating system | Microsoft Windows 11 Pro for Workstations 10.0.26200.0 |
| CPU | Intel(R) Core(TM) Ultra 9 275HX |
| C compiler | Microsoft (R) C/C++ Optimizing Compiler Version 19.51.36246 for x64 |
| CMake | cmake version 4.1.2 |
| Rust | rustc 1.91.1 (ed61e7d7e 2025-11-07) / cargo 1.91.1 (ea2d97820 2025-10-10) |
| upstream sources | SUNDIALS 7.8.0, `examples/` as copied into this repository |

Built with `cargo build --release --workspace --examples`; run by
[`tools/example_matrix.py`](../tools/example_matrix.py). Raw captured output
per variant is in [`outputs/`](outputs/).

## What "ported" means here

The examples were not written for this exercise: they are part of the port and
were translated line by line from the same C programs this comparison builds,
one Rust file per C file, keeping the C function names, constants and output
formatting. `crates/<solver>_rs/examples/<name>.rs` corresponds to
`examples/<solver>/serial/<name>.c`. All **108** in-scope serial programs are
ported and build clean; `cargo build --release --workspace --examples`
produces 0 warnings.

The port is `std`-only: no `unsafe`, no FFI, no external crates. It does not
call the host libm — `crates/sundials_core/src/sundials_libm/` implements
`exp`, `log`, `expm1`, `log1p`, `sin`, `cos`, `atan`, `asin`, `acos`, `sinh`,
`cosh` and `acosh`, and `sundials_math.rs` implements `pow`, each measured
bit-identical to glibc 2.39 over 8,000,000 inputs per routine. That is the
single most important fact for reading [`../differences/`](../differences/):
**the Rust reproduces glibc's libm, the C build links the Microsoft UCRT's.**

## Results

### Scope, and why it is what it is

The comparison covers the **six serial example directories** — `cvode/serial`,
`cvodes/serial`, `kinsol/serial`, `ida/serial`, `idas/serial` and
`arkode/C_serial` — which hold 128 C programs and, through the argv variants
their `CMakeLists.txt` files declare, **199 reference outputs**. Twenty of
those programs need KLU or SuperLU_MT and are excluded on *both* sides, so the
two sides are compared over exactly the same 179 variants.

Every other directory in `examples/` is outside this comparison because it
needs a backend that is present on neither side: MPI (`parallel`,
`C_parallel`, `C_mpimanyvector`), OpenMP (`C_openmp`), OpenMP device offload
(`C_openmpdev`), PETSc, *hypre* (`parhyp`), CUDA, HIP, SYCL, RAJA, Kokkos,
Ginkgo, Trilinos, SuperLU_DIST, ManyVector, XBraid, and the C++ and Fortran
2003 interfaces. `c-results/EXCLUSIONS.md` lists them program by program.

| outcome | variants |
|---|---:|
| ran to completion (exit 0) | **179** |
| of those, printed a solver error anyway | **0** |
| non-zero exit or timeout | **0** |
| excluded (KLU / SuperLU_MT) | **20** |
| total | 199 |

Against the reference outputs shipped with SUNDIALS 7.8.0:

| Rust vs shipped `.out` | variants |
|---|---:|
| byte-identical | **153** |
| whitespace-only difference | **15** |
| content difference | **11** |

## Files

| file | contents |
|---|---|
| [`RESULTS.md`](RESULTS.md) | every variant: exit status, output size, agreement with the shipped reference |
| [`EXCLUSIONS.md`](EXCLUSIONS.md) | every example not ported, with the reason |
| [`outputs/`](outputs/) | raw captured stdout+stderr, one file per variant |
