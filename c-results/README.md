# c-results — SUNDIALS 7.8.0 C examples built with Visual Studio 18 Professional

What the **C** implementation does on this machine. Built from the upstream
SUNDIALS 7.8.0 sources with MSVC, out of source; the upstream tree is never
written to.

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

Build script: [`tools/build_c_examples.cmd`](../tools/build_c_examples.cmd)
(library + examples) and
[`tools/build_c_lapack_substituted.cmd`](../tools/build_c_lapack_substituted.cmd)
(the four `*L` examples, see below). Run harness:
[`tools/example_matrix.py`](../tools/example_matrix.py). Raw captured stdout
for every variant is in [`outputs/`](outputs/), one file per variant, named
exactly like the reference file it corresponds to.

## Configuration

Everything requiring a third-party library is off, because none is installed
here and none is in scope for the Rust port either:

```
-DCMAKE_BUILD_TYPE=Release  -DBUILD_SHARED_LIBS=OFF  -DBUILD_STATIC_LIBS=ON
-DEXAMPLES_ENABLE_C=ON      -DSUNDIALS_INDEX_SIZE=64 -DSUNDIALS_PRECISION=double
-DENABLE_{LAPACK,KLU,SUPERLUMT,SUPERLUDIST,MPI,OPENMP,PTHREAD,HYPRE,PETSC,
          TRILINOS,CUDA,HIP,SYCL,RAJA,KOKKOS,GINKGO,XBRAID,CALIPER,ADIAK}=OFF
-DBUILD_FORTRAN_MODULE_INTERFACE=OFF
```

Generator: Ninja, driven from the `vcvars64` environment of Visual Studio 18
Professional. The build produced **363 targets with 0 errors**.

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
| of those, printed a solver error anyway | **1** |
| non-zero exit or timeout | **0** |
| excluded (KLU / SuperLU_MT) | **20** |
| total | 199 |

Against the reference outputs shipped with SUNDIALS 7.8.0:

| C vs shipped `.out` | variants |
|---|---:|
| byte-identical | **112** |
| whitespace-only difference | **13** |
| content difference | **54** |

Those shipped references were generated on a **glibc** host. This build links
the Microsoft UCRT, whose `sin`, `cos`, `exp`, `log`, `asin`, `acos`, `atan`,
`sinh`, `cosh`, `acosh` and `pow` all differ from glibc's in the last ulp
(measured: [`../evidence/windows-x86_64-ucrt/libm_fingerprint.txt`](../evidence/windows-x86_64-ucrt/libm_fingerprint.txt)).
That is the dominant reason this column is not 199, and it is a property of
the *platform*, not of the C code. See [`../differences/ANALYSIS.md`](../differences/ANALYSIS.md).

## Line endings

The MSVC C build writes **CRLF**; the Rust port and the reference `.out` files
shipped with SUNDIALS both write **LF**. That is Windows stdio text-mode
translation in the C runtime, which Rust does not do.

Taken literally it means the C build differs from every reference on every
line of every file, and from the Rust port likewise. Line-ending convention is
not a numerical result, so all comparisons here strip `\r` from both sides
before comparing — but it is stated rather than silently normalised, because
it is a genuine and total difference in the artefacts, and because the
captured outputs in `outputs/` are committed with their exact bytes
(`.gitattributes` marks them `-text`) so anyone can check.

Where a comparison below says "byte-identical", it means byte-identical after
that single normalisation, applied symmetrically.

## The four `*L` examples

`cvRoberts_dnsL`, `cvAdvDiff_bndL`, `cvsRoberts_dnsL` and `cvsAdvDiff_bndL`
call a LAPACK linear solver, and there is no LAPACK here, so the main build
skips them. They are built separately with exactly the substitution the Rust
port also makes — `sunlinsol_lapackdense.h` → `sunlinsol_dense.h`,
`SUNLinSol_LapackDense` → `SUNLinSol_Dense`, and the band equivalents — so
that both sides run the same algorithm and the comparison stays honest. This
is recorded per variant in [`RESULTS.md`](RESULTS.md).

## Files

| file | contents |
|---|---|
| [`RESULTS.md`](RESULTS.md) | every variant: exit status, output size, agreement with the shipped reference |
| [`EXCLUSIONS.md`](EXCLUSIONS.md) | every example not built, with the reason |
| [`outputs/`](outputs/) | raw captured stdout+stderr, one file per variant |
