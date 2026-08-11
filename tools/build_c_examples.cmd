@echo off
REM ===========================================================================
REM build_c_examples.cmd — build SUNDIALS 7.8.0 and its serial C examples with
REM Microsoft Visual Studio 18 Professional, capturing full provenance.
REM
REM   tools\build_c_examples.cmd [<sundials-source-dir>]
REM
REM Everything this script does is recorded under c-results\provenance\ so the
REM build can be audited without trusting any summary:
REM
REM   00-environment.txt      host, toolchain paths and versions, the compiler
REM                           and linker environment variables vcvars64 sets
REM   01-configure-cmd.txt    the literal cmake configure command line
REM   02-configure-out.txt    everything cmake printed while configuring
REM   03-CMakeCache.txt       every cache variable cmake resolved
REM   04-compile_commands.json  the exact cl.exe command line for every
REM                           translation unit, emitted by cmake
REM   05-build-cmd.txt        the literal cmake --build command line
REM   06-build-out.txt        ninja -v output: every compile and link command
REM                           line as actually executed
REM   07-targets.txt          every binary produced, with size and SHA-256
REM
REM The upstream C tree is never written to; the build tree is logs\c-build.
REM
REM SPDX-License-Identifier: BSD-3-Clause
REM ===========================================================================

setlocal
set "VSROOT=C:\Program Files\Microsoft Visual Studio\18\Professional"
set "SRC=%~1"
if "%SRC%"=="" set "SRC=C:\Users\nsh\Developer\sundials-7.8.0"
set "HERE=%~dp0.."
set "BUILD=%HERE%\logs\c-build"
set "PROV=%HERE%\c-results\provenance"

if not exist "%PROV%" mkdir "%PROV%"
if exist "%BUILD%" rmdir /s /q "%BUILD%"
mkdir "%BUILD%"

REM --------------------------------------------------------------- environment
call "%VSROOT%\VC\Auxiliary\Build\vcvars64.bat" >nul || exit /b 1

> "%PROV%\00-environment.txt" (
  echo == host ==
  ver
  echo(
  echo == date ^(UTC^) ==
  powershell -NoProfile -Command "(Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')"
  echo(
  echo == CPU ==
  powershell -NoProfile -Command "(Get-CimInstance Win32_Processor).Name"
  echo(
  echo == Visual Studio ==
  echo VSROOT = %VSROOT%
  powershell -NoProfile -Command "Get-Item '%VSROOT%\VC\Auxiliary\Build\vcvars64.bat' ^| Select-Object -ExpandProperty LastWriteTime"
  echo(
  echo == cl.exe ==
  where cl
  echo(
  echo == link.exe ==
  where link
  echo(
  echo == cmake ==
  where cmake
  cmake --version
  echo(
  echo == ninja ==
  where ninja
  ninja --version
  echo(
  echo == compiler environment set by vcvars64 ==
  echo VSCMD_ARG_TGT_ARCH = %VSCMD_ARG_TGT_ARCH%
  echo VCToolsVersion     = %VCToolsVersion%
  echo WindowsSDKVersion  = %WindowsSDKVersion%
  echo UCRTVersion        = %UCRTVersion%
  echo(
  echo INCLUDE = %INCLUDE%
  echo(
  echo LIB = %LIB%
  echo(
  echo LIBPATH = %LIBPATH%
)
REM cl.exe prints its banner to stderr and needs an input to not error out
cl 2>>"%PROV%\00-environment.txt" >nul
link 2>>"%PROV%\00-environment.txt" >nul

REM ---------------------------------------------------------------- configure
REM The literal command line below is written to 01-configure-cmd.txt verbatim
REM by echoing the same text that is executed on the following lines.
> "%PROV%\01-configure-cmd.txt" (
  echo cmake -G Ninja -S "%SRC%" -B "%BUILD%" ^^
  echo   -DCMAKE_BUILD_TYPE=Release ^^
  echo   -DCMAKE_C_COMPILER=cl ^^
  echo   -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ^^
  echo   -DBUILD_SHARED_LIBS=OFF ^^
  echo   -DBUILD_STATIC_LIBS=ON ^^
  echo   -DEXAMPLES_ENABLE_C=ON ^^
  echo   -DEXAMPLES_ENABLE_CXX=OFF ^^
  echo   -DEXAMPLES_INSTALL=OFF ^^
  echo   -DBUILD_TESTING=OFF ^^
  echo   -DSUNDIALS_INDEX_SIZE=64 ^^
  echo   -DSUNDIALS_PRECISION=double ^^
  echo   -DENABLE_LAPACK=OFF -DENABLE_KLU=OFF -DENABLE_SUPERLUMT=OFF ^^
  echo   -DENABLE_SUPERLUDIST=OFF -DENABLE_MPI=OFF -DENABLE_OPENMP=OFF ^^
  echo   -DENABLE_PTHREAD=OFF -DENABLE_HYPRE=OFF -DENABLE_PETSC=OFF ^^
  echo   -DENABLE_TRILINOS=OFF -DENABLE_CUDA=OFF -DENABLE_HIP=OFF ^^
  echo   -DENABLE_SYCL=OFF -DENABLE_RAJA=OFF -DENABLE_KOKKOS=OFF ^^
  echo   -DENABLE_GINKGO=OFF -DENABLE_XBRAID=OFF -DENABLE_CALIPER=OFF ^^
  echo   -DENABLE_ADIAK=OFF -DBUILD_FORTRAN_MODULE_INTERFACE=OFF
)

cmake -G Ninja -S "%SRC%" -B "%BUILD%" ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_C_COMPILER=cl ^
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ^
  -DBUILD_SHARED_LIBS=OFF ^
  -DBUILD_STATIC_LIBS=ON ^
  -DEXAMPLES_ENABLE_C=ON ^
  -DEXAMPLES_ENABLE_CXX=OFF ^
  -DEXAMPLES_INSTALL=OFF ^
  -DBUILD_TESTING=OFF ^
  -DSUNDIALS_INDEX_SIZE=64 ^
  -DSUNDIALS_PRECISION=double ^
  -DENABLE_LAPACK=OFF -DENABLE_KLU=OFF -DENABLE_SUPERLUMT=OFF ^
  -DENABLE_SUPERLUDIST=OFF -DENABLE_MPI=OFF -DENABLE_OPENMP=OFF ^
  -DENABLE_PTHREAD=OFF -DENABLE_HYPRE=OFF -DENABLE_PETSC=OFF ^
  -DENABLE_TRILINOS=OFF -DENABLE_CUDA=OFF -DENABLE_HIP=OFF ^
  -DENABLE_SYCL=OFF -DENABLE_RAJA=OFF -DENABLE_KOKKOS=OFF ^
  -DENABLE_GINKGO=OFF -DENABLE_XBRAID=OFF -DENABLE_CALIPER=OFF ^
  -DENABLE_ADIAK=OFF -DBUILD_FORTRAN_MODULE_INTERFACE=OFF ^
  > "%PROV%\02-configure-out.txt" 2>&1
if errorlevel 1 ( type "%PROV%\02-configure-out.txt" & exit /b 1 )

copy /y "%BUILD%\CMakeCache.txt" "%PROV%\03-CMakeCache.txt" >nul
copy /y "%BUILD%\compile_commands.json" "%PROV%\04-compile_commands.json" >nul

REM -------------------------------------------------------------------- build
> "%PROV%\05-build-cmd.txt" echo cmake --build "%BUILD%" --parallel -- -v
cmake --build "%BUILD%" --parallel -- -v > "%PROV%\06-build-out.txt" 2>&1
if errorlevel 1 ( type "%PROV%\06-build-out.txt" & exit /b 1 )

echo Build complete. Provenance in c-results\provenance\.
endlocal
