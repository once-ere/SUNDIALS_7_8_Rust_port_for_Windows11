# current_status.md — SUNDIALS_7_8_Rust_port_for_Windows11

**Read this file first when resuming.** Session of 2026-08-10.

**Status: the port builds, tests and runs clean on Windows 11 / x86-64, and
the `pow` requirement is met and proven. It is NOT byte-identical against the
upstream reference outputs, and it cannot be until further libm routines are
ported. Additional ports are required — details in §5. Nothing has been
pushed.**

| gate | result | verdict |
|---|---|---|
| `cargo build --workspace` (native `x86_64-pc-windows-msvc`) | **0 errors, 0 warnings** | PASS |
| `cargo test --workspace --lib` | **28 passed, 0 failed** | PASS |
| deterministic `pow` (built and run natively on Windows) vs **glibc `pow`**, SUNDIALS domain corpus | **5,900,000 inputs, 0 mismatches** | PASS |
| deterministic `pow` (same binary) vs **glibc `pow`**, unrestricted corpus | **20,000,000 inputs, 0 mismatches** | PASS |
| all 108 in-scope example programs build and run | 199 variants, **0 build failures, 0 run failures, 0 missing references** | PASS |
| `tools/verify_examples.sh all` (199 reference variants) | **125 IDENTICAL / 54 divergent / 20 excluded (KLU/SuperLU)** | **FAIL vs the 100 % target** |
| port defects among the 54 | **0 identified** — 26 were proven reference-side on glibc; the other 28 are attributed to the host libm by direct measurement (§4) | — |

Measured host: Windows 11 Pro for Workstations 10.0.26200.8655 (25H2),
Intel Core Ultra 9 275HX (FMA/AVX2), `ucrtbase.dll` 10.0.26100.8521,
rustc/cargo 1.91.1, target `x86_64-pc-windows-msvc`, harness run from Git
Bash (MSYS2 3.6.5). The glibc reference oracle came from the WSL2 guest
`Ubuntu-24.04` (glibc 2.39-0ubuntu8.7).

Raw artefacts are committed under
[`evidence/windows-x86_64-ucrt/`](evidence/windows-x86_64-ucrt/).

> ### Not published
>
> The remote `origin` is set to
> `https://github.com/once-ere/SUNDIALS_7_8_Rust_port_for_Windows11.git`
> but **nothing has been pushed**, because the task's push condition ("no
> errors and no warnings") is met while its other condition ("additional
> ports must be performed") is also met — see §5. Awaiting instructions.
>
> When a push is authorised, note the credential problem the sibling Linux
> port recorded on this machine: `credential.helper` is globally set to
> `manager-core`, a name Git Credential Manager retired, and no such binary
> exists here (the installed one is
> `C:\Program Files\Git\mingw64\bin\git-credential-manager.exe`). Fix with
> `git config --global credential.helper manager` — a global git-config
> change, so it is left for the user to make.

---

## 1. What was done

A pure-Rust port of SUNDIALS 7.8.0 scoped to **Windows 11 on Intel/AMD
x86-64**. No `unsafe`, no FFI, no external crates, `std` only. Seven crates,
141 modules, one per upstream C file, keeping the exact C names, constants
and return-flag conventions.

Per the task's hard requirement, it **reuses the entire crate tree** of the
sibling port `SUNDIALS_7_8_Rust_port_for_AppleSilicon_macos`, where the 141
modules were originally translated from the C sources. Not one line of
solver code was re-derived. The tree arrived here by way of
`SUNDIALS_7_8_Rust_port_for_Linux`, whose only crate-level difference from
the macOS original is the `pow` differential test in `sundials_math.rs`;
`diff -rq` over the two `crates/` trees reports that single file.

New in this repository:

| file | what it is |
|---|---|
| `tools/pow_differential_win.sh` | Windows-native `pow` differential. Builds the glibc reference oracle inside a WSL2 guest and feeds it to the natively built, natively run Windows test binary. |
| `tools/libm_probe.rs` | Host-libm fingerprint, written in Rust so the same source can be built on both hosts. Hashes 1,000,000 results per function. |
| `tools/libm_fingerprint_win.sh` | Runs that probe on Windows and inside the WSL2 guest and diffs the two fingerprints (§4). |
| `sundials_math.rs::pow_deterministic_vs_host_powf` | In-process comparison of the deterministic `pow` against whatever `f64::powf` resolves to in this build — on Windows, the UCRT `pow`. |
| `tools/verify_examples.sh` (changed) | The upstream C tree no longer has to be the workspace's parent directory; `$SUNDIALS_C_TREE` names it. Example binaries get `.exe`. |
| `tools/classify_diffs.sh` (changed) | Same `$SUNDIALS_C_TREE` override. |
| `evidence/windows-x86_64-ucrt/` | Every measurement quoted in this file. |

## 2. The `pow` requirement — met, and proven on this platform

The task required, at minimum, that `pow.c` be ported to a pure-Rust `pow`
for Windows 11 on Intel/AMD x86-64, on the grounds that the deterministic
`pow` inherited from the macOS port is a translation of the **ARM
optimized-routines / musl** implementation.

**The algorithm needed no rewrite; what it needed was a Windows
measurement, and that measurement now exists.** Three facts settle it:

1. **The ARM routine is the x86-64 routine.** ARM's optimized-routines
   `pow` is what glibc ≥ 2.28 ships as `sysdeps/ieee754/dbl-64/e_pow.c`; on
   x86-64 glibc ifunc-dispatches to `__ieee754_pow_fma`, the same source
   rebuilt with `-mfma -mavx2 -ffp-contract=fast`. The Rust routine already
   reproduces that FMA-contracted build's contraction map. Nothing in it is
   AArch64-specific: it is `std`-only Rust with no `cfg(target_arch)`, and
   `f64::mul_add` is a fused, correctly-rounded operation on every Rust
   target.
2. **It is bit-exact against glibc when built by the Windows toolchain.**
   `tools/pow_differential_win.sh` builds the oracle (`tools/pow_oracle.c`)
   with the guest's `cc` inside WSL2 — real glibc, real x86-64 — and hands
   the bit-stream to a test binary compiled by `x86_64-pc-windows-msvc` and
   executed natively on Windows. Result: **0 mismatches over 5,900,000
   inputs in the domain SUNDIALS evaluates, and 0 over 20,000,000
   unrestricted finite inputs.** Both sides regenerate the corpus from the
   same splitmix64 recurrence, so they cannot disagree about which inputs
   they evaluated.
3. **On Windows it is load-bearing, which it was not on Linux.** The host
   `pow` here is the Microsoft UCRT one, and it is *not* the routine that
   generated the upstream reference outputs.
   `pow_deterministic_vs_host_powf` measures the gap in process:
   **4,926 of the same 5,900,000 domain inputs — 1 in 1,198 — round
   differently, always by exactly 1 ulp.** Had `SUNRpowerR` called
   `f64::powf`, those would be wrong digits inside the step-size
   controllers of every adaptive integrator in the suite.

Writing a second, Windows-specific `pow` was considered and rejected: it
would replace a routine *measured* bit-exact against the target with an
unmeasured rewrite. The Gemini-suggested C skeleton in the task prompt is
the same ARM algorithm with an `exp(y*log(x))` tail spliced in place of the
exact `exp_inline` reconstruction, elided lookup tables, and a fallback to
the host `pow` for special cases — i.e. it is neither pure Rust nor
bit-exact, and adopting it would have *reintroduced* the UCRT dependency
this port exists to remove. The provenance and the licence of the routine
actually used are recorded in `NOTICE` and `POW_FMA_EXACTNESS.md`.

## 3. Verification gate — Windows vs the sibling ports

| | macOS / arm64 | Linux / x86-64 glibc | **Windows 11 / x86-64 UCRT (here)** |
|---|---:|---:|---:|
| IDENTICAL | 127 | 153 | **125** |
| divergent | 52 | 26 | **54** |
| excluded (KLU/SuperLU) | 20 | 20 | 20 |
| build failures / run failures | 0 | 0 | **0** |
| total variants | 199 | 199 | 199 |

The Windows divergence set is a strict **superset** of the Linux one:
`comm` over the two summaries shows all 26 Linux divergences present here,
plus exactly 28 more, with no Linux divergence resolved. That nesting is
what makes the result interpretable.

Second-pass classification (`tools/classify_diffs.sh`): of the 54, **14 are
whitespace-only** — `tr -s ' '` empties the diff, so every printed *value*
is byte-identical and only column spacing differs (`SUN_TABLE_WIDTH`
28 → 29 in references that predate the change). The other 40 have real
content differences.

## 4. Why the 28 extra variants diverge — measured, not assumed

The port takes `sin`, `cos`, `exp`, `ln`, `asin`, `acos`, `atan`, `sinh`,
`cosh` and `acosh` from the host through `f64`'s methods, which Rust
documents as having *unspecified precision*. Only `pow` was made
host-independent. On glibc that is harmless, because the host libm then
*is* the libm that generated the references. On Windows it is not.

`tools/libm_fingerprint_win.sh` builds the same Rust probe on both hosts and
hashes 1,000,000 results per function:

| function | Windows UCRT vs Linux glibc 2.39 |
|---|---|
| `sqrt` | **same** (IEEE-754 specifies it) |
| `sin`, `cos`, `tan`, `exp`, `ln`, `log10`, `asin`, `acos`, `atan`, `sinh`, `cosh`, `acosh`, `tanh` | **all differ** |
| `powf` (the host routine, i.e. what the port does *not* call) | **differs** |

Every one of the 28 Windows-only divergent variants evaluates at least one
of the differing functions, and the mapping is exact:

| variant family | host functions it evaluates |
|---|---|
| `cvDiurnal_kry`, `cvDiurnal_kry_bp`, `cvKrylovDemo_ls` (4 argv variants), `cvsDiurnal_kry`, `cvsDiurnal_kry_bp`, `cvsDiurnal_FSA_kry` (2) | `exp`, `sin` |
| `idaFoodWeb_bnd`, `idaFoodWeb_kry`, `idasFoodWeb_bnd` | `sin` |
| `idasSlCrank_dns`, `idasSlCrank_FSA_dns` | `sin`, `cos`, `asin`, `atan` |
| `ark_analytic_lsrk`, `ark_analytic_lsrk_varjac`, `ark_analytic_lsrk_domeigest` (2) | `atan`, `cos`, `acos` in the example; `ln`, `sinh`, `cosh`, `acosh` in `arkode_lsrkstep.rs:82–97` |
| `ark_analytic_ssprk` | `atan` |
| `ark_conserved_exp_entropy_ark`, `ark_conserved_exp_entropy_erk`, `ark_dissipated_exp_entropy` | `exp`, `ln` |
| `ark_kpr_mri` (5 argv variants) | `sin`, `cos` |

One further variant, `ark_harmonic_symplectic`, is inside the inherited 26
but changes class here: whitespace-only on glibc, content-divergent on
Windows, because it evaluates `sin` and `cos`. **So 29 of the 54 are
host-libm effects.**

**Attribution argument.** The Rust source is byte-identical to the Linux
port's (one test function aside), and on glibc/x86-64 those same 28 variants
are IDENTICAL. The arithmetic performed by the port is therefore the same;
the only quantity that changed is the value the host libm returns. That is
the cause. What has *not* been done on Windows is the stronger proof the
Linux port made — building the pristine upstream C on this host and showing
Rust == C — see §6 item 1.

## 5. Deficiencies and requirements — what "additional ports" means

To make this port byte-identical against the upstream reference outputs on
Windows, the remaining host-libm routines must be ported to pure Rust the
way `pow` was, reproducing **glibc's** algorithms (the references were
generated on glibc).

**Required ports, in dependency order.** glibc's `exp` and `log` come from
the same ARM optimized-routines family as the `pow` already ported, and
share its table/polynomial style, so they are the cheapest and they unblock
the hyperbolics:

| # | routine | glibc source | needed by | notes |
|---|---|---|---|---|
| 1 | `exp` | `sysdeps/ieee754/dbl-64/e_exp.c` (ARM optimized-routines, 128-entry table, FMA-contracted on x86-64) | 5 library call sites (`SUNRexp` in `sundials_math.rs`, `cvodes.rs`, `idas.rs`) and 59 example sites; the Diurnal, FoodWeb and entropy families | same shape as the ported `pow`; the `exp_data` table is already half-present, since `pow`'s tail uses it |
| 2 | `log` / `ln` | `sysdeps/ieee754/dbl-64/e_log.c` (same family) | 1 library site (`arkode_lsrkstep.rs:82`) + 12 example sites; the entropy family | same shape |
| 3 | `sin`, `cos` | `sysdeps/ieee754/dbl-64/s_sin.c` + `dosincos.c`, `branred.c` (IBM Accurate Portable Math Library) | 53 + 44 example sites; Diurnal, FoodWeb, SlCrank, kepler, kpr_mri, harmonic families | largest item: big tables (`usncs.h`), a multi-branch argument reduction and a Payne–Hanek path |
| 4 | `atan` | `sysdeps/ieee754/dbl-64/s_atan.c` (IBM APML, `atnat.h` tables) | 24 example sites; LSRK and SlCrank families | |
| 5 | `asin`, `acos` | `sysdeps/ieee754/dbl-64/e_asin.c` (IBM APML, `asincos.tbl`) | 3 + 5 example sites; SlCrank, LSRK-domeigest | |
| 6 | `sinh`, `cosh`, `acosh` | `e_sinh.c`, `e_cosh.c`, `e_acosh.c` | 3 library sites, all in `arkode_lsrkstep.rs:87–97` | thin wrappers over items 1–2 once those exist; also fixes the 3 variants the Linux port loses on glibc 2.44 |
| 7 | `tan`, `log10`, `tanh` | — | **not used anywhere in the port or its examples** | probed only as fingerprint controls; no port needed |

**Estimated size:** items 1, 2, 6 are comparable to the `pow` already in
the tree (~350 lines of Rust plus tables each). Item 3 is several times
that. Each one needs the same evidence the `pow` has: a differential test
against a glibc oracle over a domain corpus and an unrestricted corpus,
driven by `tools/pow_differential_win.sh` extended to the new routines.

**Expected effect.** Closing items 1–6 should move all 29 host-libm
variants to IDENTICAL, taking the gate to **154 IDENTICAL / 25 divergent /
20 excluded** — i.e. one better than the Linux port, which loses
`ark_harmonic_symplectic` to whitespace only. The residual 25 are the
reference-side divergences the Linux port already root-caused against
pristine C (stale `SUN_TABLE_WIDTH` spacing, two LAPACK→native
substitutions, two upstream `.out` anomalies, five references with trailing
whitespace stripped, two missing a final blank line).

**The alternative** — declaring Windows byte-identity out of scope and
scoping the port to "builds, runs and is numerically correct on Windows,
with byte-identity claimed only where the host libm agrees with glibc" — is
a documentation decision, not an engineering one, and is what the macOS
port did for the same reason. It requires no further ports. This is the
user's call, which is why nothing has been pushed.

## 6. Open items (not blocking, would strengthen the evidence)

1. **Pristine C build on Windows.** Build upstream SUNDIALS 7.8.0 with
   cmake + MSVC/clang-cl here and compare Rust vs that C vs the shipped
   `.out` for all 54 divergences, the way `tools/pristine_c_build.sh` and
   `tools/compare_pristine_c.sh` did on Linux. Expected: Rust == C on all
   54, which would upgrade §4's attribution from a deduction to a
   measurement and prove 0 port defects natively.
2. **Bare-metal glibc oracle.** The `pow` reference oracle came from a WSL2
   guest. That is a real glibc/x86-64 userspace and the arithmetic cannot
   differ, but an oracle from a physical Linux box would remove the last
   question.
3. **Windows-on-ARM.** Out of scope here and untested. The Rust sources
   carry no `cfg(target_arch)`, so they would compile; every numerical
   claim would have to be re-measured.

## 7. How to reproduce, from a clean checkout

On Windows 11 x86-64 with rustup, Git Bash, and (for the oracle) a WSL2
Linux guest:

```bash
cargo build --workspace                 # 0 warnings
cargo test  --workspace --lib           # 28 passed
tools/pow_differential_win.sh all       # 0 mismatches / 25.9M inputs
tools/libm_fingerprint_win.sh           # which host functions differ from glibc
```

The example gate additionally needs the read-only upstream SUNDIALS 7.8.0 C
tree; unlike the sibling ports this workspace does not live inside it, so
name it explicitly:

```bash
SUNDIALS_C_TREE=/c/Users/nsh/Developer/sundials-7.8.0 tools/verify_examples.sh all
SUNDIALS_C_TREE=/c/Users/nsh/Developer/sundials-7.8.0 tools/classify_diffs.sh
```

Then read `logs/summary.txt` and `logs/classify_diffs.txt`.

## 8. Provenance

* **Upstream:** SUNDIALS 7.8.0, LLNL, BSD-3-Clause. Read-only reference at
  `C:\Users\nsh\Developer\sundials-7.8.0` on the machine this was built on.
* **Crate tree:** inherited wholesale from
  `SUNDIALS_7_8_Rust_port_for_AppleSilicon_macos` (BSD-3-Clause, same author
  lineage), by way of `SUNDIALS_7_8_Rust_port_for_Linux`. `ARCHITECTURE.md`,
  `PROGRESS.md` and the body of `VERIFICATION.md` come from there and
  describe the translation, which is platform-independent.
* **Deterministic `pow`:** ARM optimized-routines via musl `src/math/pow.c`,
  `pow_data.c`, `exp_data.c` — MIT, © 2018 Arm Limited; the algorithm glibc
  ≥ 2.28 ships. See `NOTICE` and `POW_FMA_EXACTNESS.md`.
* **`rand()` reproduction** in three `ark_*_lsrk_domeigest` examples: the
  BSD/glibc TYPE_3 additive-feedback generator, reimplemented in Rust
  because the draws are output-observable. See `NOTICE`.
* **New here:** `tools/pow_differential_win.sh`, `tools/libm_probe.rs`,
  `tools/libm_fingerprint_win.sh`, the `pow_deterministic_vs_host_powf`
  test, the `$SUNDIALS_C_TREE` support in the two harness scripts,
  `evidence/windows-x86_64-ucrt/`, this file, and the Windows scoping of
  `README.md`, `CLAUDE.md`, `VERIFICATION.md`, `STATUS.md` and
  `POW_FMA_EXACTNESS.md`.
