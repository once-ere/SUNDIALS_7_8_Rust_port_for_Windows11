# SUNDIALS_7_8_Rust_port_for_Windows11

A line-by-line translation of [SUNDIALS](https://github.com/LLNL/sundials)
7.8.0 into safe Rust, scoped to **Windows 11 on Intel/AMD x86-64**. **No
`unsafe`, no FFI, no external crates, no build warnings.**

**→ Read [`current_status.md`](current_status.md) first.** It is the
authoritative statement of what is measured, what is not, and what remains.

## Where this port stands

| gate | result |
|---|---|
| `cargo build --workspace`, native `x86_64-pc-windows-msvc` | **0 errors, 0 warnings** |
| `cargo test --workspace --lib` | **28 passed, 0 failed** |
| all 108 in-scope example programs build and run (199 argv variants) | **0 build failures, 0 run failures** |
| deterministic `pow`, built and run natively on Windows, vs **glibc `pow`** | **0 mismatches over 25,900,000 inputs** |
| `tools/verify_examples.sh all` — byte-identity against the upstream references | **125 IDENTICAL / 54 divergent / 20 excluded (KLU/SuperLU)** |
| port defects among the 54 | **0 identified** — 26 proven reference-side on glibc, 28 attributed to the Windows host libm by direct measurement |

The last row is the honest headline: **this port is not byte-identical to
the upstream reference outputs on Windows, and it will not be until further
libm routines are ported.** `current_status.md` §5 lists exactly which ones,
why, and what each would buy.

## Headline facts

* 7 crates: `sundials_core` plus `cvode_rs`, `cvodes_rs`, `kinsol_rs`,
  `ida_rs`, `idas_rs`, `arkode_rs`. Solver crates depend on the core, never
  on each other.
* 141 modules, one per upstream C file, keeping the exact C function names,
  constants and return-flag conventions (`CV_SUCCESS = 0`; negative fatal,
  positive recoverable).
* Serial only. No MPI, GPU, KLU, SuperLU, LAPACK, Fortran or XBraid backends.
* The crate tree is **inherited unchanged** from the sibling port
  [`SUNDIALS_7_8_Rust_port_for_AppleSilicon_macos`](https://github.com/once-ere/SUNDIALS_7_8_Rust_port_for_AppleSilicon_macos),
  where the 141 modules were translated from the C sources. No solver code
  is re-derived here. The work in this repository is target-platform work.

## Quick start

```bash
cargo build --workspace
cargo run -p cvode_rs --example cvRoberts_dns
```

```rust
use cvode_rs::prelude::*;
```

The verification harness is a POSIX `bash` script — run it from **Git Bash**
or MSYS2, not `cmd.exe` or PowerShell — and it needs the read-only upstream
SUNDIALS 7.8.0 C tree, which this workspace does *not* sit inside:

```bash
SUNDIALS_C_TREE=/c/Users/nsh/Developer/sundials-7.8.0 tools/verify_examples.sh all
```

## Platform scope

**Every numerical result claimed here was established on Windows 11 Pro for
Workstations 10.0.26200 (25H2), x86-64, `ucrtbase.dll` 10.0.26100.8521,
rustc 1.91.1, target `x86_64-pc-windows-msvc`.** The Rust sources are
portable — `std` only, no `unsafe`, no FFI, no `cfg(target_os)` or
`cfg(target_arch)` anywhere in the tree — so they compile and unit-test on
any target Rust supports. What does not travel is the numerical evidence.

### Why byte-identity is hard on Windows

The upstream reference `.out` files were generated on a **glibc** host. The
port evaluates `sin`, `cos`, `exp`, `ln`, `asin`, `acos`, `atan`, `sinh`,
`cosh` and `acosh` through `f64` methods that Rust documents as having
*unspecified precision* and that forward to the **host** libm — on this
target, the Microsoft UCRT. `tools/libm_fingerprint_win.sh` builds the same
Rust probe natively on Windows and inside a WSL2 glibc guest and hashes
1,000,000 results per function. The verdict:

| function | Windows UCRT vs glibc 2.39 |
|---|---|
| `sqrt` | **same** — IEEE-754 specifies it |
| `sin`, `cos`, `tan`, `exp`, `ln`, `log10`, `asin`, `acos`, `atan`, `sinh`, `cosh`, `acosh`, `tanh` | **all differ** |
| `powf` — the host routine this port deliberately does *not* call | **differs** |

Inside an adaptive integrator a one-ulp difference forks the step-size
trajectory and therefore the printed output. That is the whole of the gap
between 125 IDENTICAL here and 153 on the Linux sibling: the 54 divergent
variants are a strict superset of that port's 26, and every one of the 28
extra evaluates at least one differing function.

### `pow` is the one that was fixed

`crates/sundials_core/src/sundials_math.rs` contains `pow_glibc`, a
pure-Rust port of the ARM optimized-routines / musl `pow` (MIT, © 2018 Arm
Limited) — the same algorithm glibc ≥ 2.28 ships as
`sysdeps/ieee754/dbl-64/e_pow.c`, and on x86-64 the same FMA-contracted
build glibc ifunc-dispatches to as `__ieee754_pow_fma`. `SUNRpowerR` routes
through it instead of `f64::powf`, which takes the host libm out of the
`pow` path — **and only the `pow` path.**

On Windows that substitution is load-bearing, and both halves of the claim
are measured natively:

* **vs glibc:** `tools/pow_differential_win.sh` builds the oracle inside a
  WSL2 Linux guest (real glibc, real x86-64) and feeds it to a test binary
  compiled by `x86_64-pc-windows-msvc` and run natively. **0 mismatches over
  5,900,000 domain inputs and 0 over 20,000,000 unrestricted finite
  inputs.**
* **vs the host:** `pow_deterministic_vs_host_powf` compares it in process
  against the UCRT `pow`. **4,926 of those 5,900,000 domain inputs — 1 in
  1,198 — round differently, always by 1 ulp.** Every one of those is a
  digit the port would have got wrong had it called `f64::powf`.

`pow` is the only *libm* substitution, but not the only host-C-library one:
`ark_analytic_lsrk_domeigest`, `ark_brusselator_lsrk_domeigest` and
`ark_brusselator_lsrk_externaldomeigest` reproduce the BSD/glibc `rand()`
TYPE_3 additive-feedback generator in Rust, sequence for sequence, because
those examples feed pseudo-random vectors into a dominant-eigenvalue
estimator and the draws are output-observable. See [`NOTICE`](NOTICE).

### What would close the gap

Porting `exp`, `log`, `sin`, `cos`, `atan`, `asin`, `acos`, `sinh`, `cosh`
and `acosh` to pure Rust the way `pow` was — reproducing glibc's algorithms,
each with its own differential test against a glibc oracle. glibc's `exp`
and `log` are from the same ARM optimized-routines family as the `pow`
already here and are the cheapest; `sin`/`cos` (IBM Accurate Portable Math
Library) are the largest item. Expected result: **154 IDENTICAL / 25
divergent / 20 excluded.** The full breakdown, with call-site counts and
per-routine sources, is [`current_status.md`](current_status.md) §5.

## Sibling ports

Each platform is a separate repository, never conditional compilation
inside one tree.

| repository | target | gate |
|---|---|---|
| [`…_for_AppleSilicon_macos`](https://github.com/once-ere/SUNDIALS_7_8_Rust_port_for_AppleSilicon_macos) | macOS / arm64 / Apple libm | 127 / 52 / 20 |
| [`…_for_Linux`](https://github.com/once-ere/SUNDIALS_7_8_Rust_port_for_Linux) | Linux / x86-64 / glibc 2.36–2.41 | 153 / 26 / 20 |
| **this one** | Windows 11 / x86-64 / UCRT | **125 / 54 / 20** |

## Documentation

| file | contents |
|---|---|
| [`current_status.md`](current_status.md) | **start here** — measured state, deficiencies, what remains |
| [`sundials.md`](sundials.md) | public guide — crate map, worked example, C-to-Rust API conventions |
| [`ARCHITECTURE.md`](ARCHITECTURE.md) | handle model, locked porting patterns, numbered deviation classes |
| [`VERIFICATION.md`](VERIFICATION.md) | per-variant matrix: Windows results, then the inherited Linux and macOS evidence |
| [`PROGRESS.md`](PROGRESS.md) | per-file port status |
| [`STATUS.md`](STATUS.md) | what is done, what remains, how to resume |
| [`POW_FMA_EXACTNESS.md`](POW_FMA_EXACTNESS.md) | how far the deterministic `pow` is bit-exact, and the limits of that claim |
| [`evidence/windows-x86_64-ucrt/`](evidence/windows-x86_64-ucrt/) | raw artefacts behind every number above |

## Licence

Derivative work of SUNDIALS, **BSD-3-Clause**, Copyright © 2002–2026
Lawrence Livermore National Security, Southern Methodist University,
University of Maryland Baltimore County and the SUNDIALS contributors.

The deterministic `pow` in `crates/sundials_core/src/sundials_math.rs` is a
pure-Rust port of the ARM optimized-routines `pow` (taken via musl's
`src/math/pow.c`, `pow_data.c` and `exp_data.c`), **MIT**, Copyright © 2018
Arm Limited. It is not an ARM-specific routine — it is host-independent
Rust, used here precisely *because* the host libm on this platform is not
the one the references came from.

Not an LLNL product; not endorsed by the SUNDIALS project. See `sundials.md`
§8 and `NOTICE`.
