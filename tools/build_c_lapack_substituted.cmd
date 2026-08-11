@echo off
REM build_c_lapack_substituted.cmd — build the four *L examples against the
REM native dense/band solvers instead of LAPACK.
REM
REM cvAdvDiff_bndL, cvRoberts_dnsL, cvsAdvDiff_bndL and cvsRoberts_dnsL are the
REM only in-scope serial examples that call a LAPACK linear solver. No LAPACK is
REM present here, so the main build skips them; the Rust port instead ports them
REM onto the native solvers, substituting exactly two tokens per file:
REM
REM     sunlinsol_lapackdense.h  ->  sunlinsol_dense.h
REM     SUNLinSol_LapackDense    ->  SUNLinSol_Dense
REM     sunlinsol_lapackband.h   ->  sunlinsol_band.h
REM     SUNLinSol_LapackBand     ->  SUNLinSol_Band
REM
REM To compare like with like, this script applies the *same* two substitutions
REM to the C sources and builds them against the C library that the main build
REM produced. The substituted sources go to logs\c-build\lapack-sub\ — the
REM upstream tree is never written to.
REM
REM Run tools\build_c_examples.cmd first.
REM
REM SPDX-License-Identifier: BSD-3-Clause

setlocal enabledelayedexpansion
set "VSROOT=C:\Program Files\Microsoft Visual Studio\18\Professional"
set "HERE=%~dp0.."
set "SRC=%~1"
if "%SRC%"=="" set "SRC=C:\Users\nsh\Developer\sundials-7.8.0"
set "BUILD=%HERE%\logs\c-build"
set "SUB=%BUILD%\lapack-sub"

call "%VSROOT%\VC\Auxiliary\Build\vcvars64.bat" >nul || exit /b 1
if not exist "%SUB%" mkdir "%SUB%"

for %%P in (cvode\serial\cvRoberts_dnsL cvode\serial\cvAdvDiff_bndL cvodes\serial\cvsRoberts_dnsL cvodes\serial\cvsAdvDiff_bndL) do (
  set "NAME=%%~nP"
  echo === !NAME! ===
  powershell -NoProfile -Command ^
    "(Get-Content '%SRC%\examples\%%P.c' -Raw)" ^
    " -replace 'sunlinsol/sunlinsol_lapackdense.h','sunlinsol/sunlinsol_dense.h'" ^
    " -replace 'sunlinsol/sunlinsol_lapackband.h','sunlinsol/sunlinsol_band.h'" ^
    " -replace 'SUNLinSol_LapackDense','SUNLinSol_Dense'" ^
    " -replace 'SUNLinSol_LapackBand','SUNLinSol_Band'" ^
    " | Set-Content '%SUB%\!NAME!.c' -NoNewline"
  cl /nologo /O2 /MD /I"%SRC%\include" /I"%BUILD%\include" ^
     "%SUB%\!NAME!.c" ^
     /Fo"%SUB%\!NAME!.obj" /Fe"%BUILD%\bin\!NAME!.exe" ^
     /link /LIBPATH:"%BUILD%\bin" ^
     sundials_cvode_static.lib sundials_cvodes_static.lib sundials_core_static.lib ^
     sundials_nvecserial_static.lib sundials_sunmatrixdense_static.lib ^
     sundials_sunmatrixband_static.lib sundials_sunlinsoldense_static.lib ^
     sundials_sunlinsolband_static.lib sundials_sunnonlinsolnewton_static.lib ^
     sundials_sunnonlinsolfixedpoint_static.lib ^
     || echo   FAILED !NAME!
)
endlocal
