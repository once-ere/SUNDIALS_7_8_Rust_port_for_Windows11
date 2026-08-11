# Exclusions

## Serial examples excluded on both sides (20 programs, 20 variants)

These need KLU or SuperLU_MT. Neither library is installed, the C build skips
them, and the Rust port excludes them by specification — so they are excluded
symmetrically and no comparison is affected.

| example | argv | dir | reason |
|---|---|---|---|
| `cvRoberts_block_klu` |  | cvode/serial | excluded(klu) |
| `cvRoberts_klu` |  | cvode/serial | excluded(klu) |
| `cvRoberts_sps` |  | cvode/serial | excluded(superlu) |
| `cvsRoberts_ASAi_klu` |  | cvodes/serial | excluded(klu) |
| `cvsRoberts_FSA_klu` | `-sensi stg1 t` | cvodes/serial | excluded(klu) |
| `cvsRoberts_klu` |  | cvodes/serial | excluded(klu) |
| `cvsRoberts_ASAi_sps` |  | cvodes/serial | excluded(superlu) |
| `cvsRoberts_FSA_sps` | `-sensi stg1 t` | cvodes/serial | excluded(superlu) |
| `cvsRoberts_sps` |  | cvodes/serial | excluded(superlu) |
| `kinFerTron_klu` |  | kinsol/serial | excluded(klu) |
| `kinRoboKin_slu` |  | kinsol/serial | excluded(superlu) |
| `idaHeat2D_klu` |  | ida/serial | excluded(klu) |
| `idaRoberts_klu` |  | ida/serial | excluded(klu) |
| `idaRoberts_sps` |  | ida/serial | excluded(superlu) |
| `idasRoberts_ASAi_klu` |  | idas/serial | excluded(klu) |
| `idasRoberts_FSA_klu` | `-sensi stg t` | idas/serial | excluded(klu) |
| `idasRoberts_klu` |  | idas/serial | excluded(klu) |
| `idasRoberts_ASAi_sps` |  | idas/serial | excluded(superlu) |
| `idasRoberts_FSA_sps` | `-sensi stg t` | idas/serial | excluded(superlu) |
| `idasRoberts_sps` |  | idas/serial | excluded(superlu) |

## Directories outside the comparison

Every one needs a backend present on neither side. Counts are C source files.

| directory | programs | requires |
|---|---:|---|
| `arkode/C_klu`, `arkode/C_superlu-mt` | 2 | KLU / SuperLU_MT |
| `arkode/C_manyvector`, `cvode/C_mpimanyvector` | 2 | ManyVector (+ MPI) |
| `arkode/C_openmp`, `cvode/C_openmp`, `cvodes/C_openmp`, `ida/C_openmp`, `idas/C_openmp`, `kinsol/C_openmp` | 9 | OpenMP N_Vector |
| `arkode/C_openmpdev`, `cvode/C_openmpdev` | 4 | OpenMP device offload |
| `arkode/C_parallel`, `cvode/parallel`, `cvodes/parallel`, `ida/parallel`, `idas/parallel`, `kinsol/parallel` | 28 | MPI |
| `arkode/C_parhyp`, `cvode/parhyp` | 2 | *hypre* |
| `arkode/C_petsc`, `cvode/petsc`, `ida/petsc` | 5 | PETSc |
| C++ sources (`*.cpp`) | 46 | CUDA / HIP / SYCL / RAJA / Kokkos / Ginkgo / Trilinos / C++ interface |
| Fortran sources (`*.f90`) | 51 | Fortran 2003 interface |
| CUDA sources (`*.cu`) | 7 | CUDA |

The Rust port excludes all of these by specification: it is serial-only, with
no MPI, GPU, KLU, SuperLU, LAPACK, Fortran or XBraid backend. Porting them
would mean first porting those backends, which is out of scope for a
`std`-only translation.
