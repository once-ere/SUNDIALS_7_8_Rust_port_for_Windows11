@echo off
REM build_c_examples.cmd — build SUNDIALS 7.8.0 and its serial C examples with
REM Microsoft Visual Studio 18 Professional (MSVC / cl.exe), out of source.
REM
REM The upstream C tree stays read-only: nothing is written inside it. The
REM build tree lands in logs\c-build (gitignored) and the binaries in
REM logs\c-build\examples\.
REM
REM   tools\build_c_examples.cmd [<sundials-source-dir>]
REM
REM Everything that needs a third-party library is switched off, because none
REM of them is present on this machine and none is in scope for the Rust port
REM either: LAPACK, KLU, SuperLU_MT/DIST, MPI, OpenMP, PETSc, hypre, Trilinos,
REM CUDA, HIP, SYCL, RAJA, Kokkos, Ginkgo, XBraid, Fortran. That leaves the
REM serial C examples, which is exactly the set the Rust port covers.
REM
REM SPDX-License-Identifier: BSD-3-Clause

setlocal
set "VSROOT=C:\Program Files\Microsoft Visual Studio\18\Professional"
set "SRC=%~1"
if "%SRC%"=="" set "SRC=C:\Users\nsh\Developer\sundials-7.8.0"
set "HERE=%~dp0.."
set "BUILD=%HERE%\logs\c-build"

call "%VSROOT%\VC\Auxiliary\Build\vcvars64.bat" || exit /b 1
echo(
echo === toolchain ===
cl 2>&1 | findstr /C:"Version"
cmake --version | findstr /C:"cmake version"
echo(

if not exist "%BUILD%" mkdir "%BUILD%"

echo === configure ===
cmake -G Ninja -S "%SRC%" -B "%BUILD%" ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_C_COMPILER=cl ^
  -DBUILD_SHARED_LIBS=OFF ^
  -DBUILD_STATIC_LIBS=ON ^
  -DEXAMPLES_ENABLE_C=ON ^
  -DEXAMPLES_ENABLE_CXX=OFF ^
  -DEXAMPLES_INSTALL=OFF ^
  -DBUILD_TESTING=OFF ^
  -DENABLE_LAPACK=OFF ^
  -DENABLE_KLU=OFF ^
  -DENABLE_SUPERLUMT=OFF ^
  -DENABLE_SUPERLUDIST=OFF ^
  -DENABLE_MPI=OFF ^
  -DENABLE_OPENMP=OFF ^
  -DENABLE_PTHREAD=OFF ^
  -DENABLE_HYPRE=OFF ^
  -DENABLE_PETSC=OFF ^
  -DENABLE_TRILINOS=OFF ^
  -DENABLE_CUDA=OFF ^
  -DENABLE_HIP=OFF ^
  -DENABLE_SYCL=OFF ^
  -DENABLE_RAJA=OFF ^
  -DENABLE_KOKKOS=OFF ^
  -DENABLE_GINKGO=OFF ^
  -DENABLE_XBRAID=OFF ^
  -DENABLE_CALIPER=OFF ^
  -DENABLE_ADIAK=OFF ^
  -DBUILD_FORTRAN_MODULE_INTERFACE=OFF ^
  -DSUNDIALS_INDEX_SIZE=64 ^
  -DSUNDIALS_PRECISION=double || exit /b 1

echo(
echo === build ===
cmake --build "%BUILD%" --parallel || exit /b 1

echo(
echo === done ===
endlocal
