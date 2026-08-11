# VERIFY.md — how to check every claim in this repository yourself

This document assumes you know nothing about this project. It tells you what
was done, what evidence was recorded, where that evidence is, and what to type
to confirm it. Nothing here asks you to take a summary on trust: every number
quoted in `c-results/`, `rust-results/` and `differences/` traces to a file you
can open or a command you can re-run.

If you only do one thing, do **Check 1** — it takes a minute and confirms the
files you have are the files that were measured.

---

## 0. What the evidence consists of

| directory | what it holds |
|---|---|
| `examples/` | the SUNDIALS 7.8.0 C example sources and their expected outputs, copied from the upstream release |
| `c-results/provenance/` | how the C was built: environment, tool versions, every command line, every compiler invocation, checksums |
| `rust-results/provenance/` | the same for the Rust build |
| `differences/provenance/` | checksums of the reference outputs, and proof the sources in this repository are the ones that were compiled |
| `c-results/outputs/`, `rust-results/outputs/` | the raw text each program printed, one file per run |
| `differences/diffs/` | a line-by-line diff for every case where the two disagreed |

"Provenance" here means: for each result, the recorded origin and chain of
custody — which exact input file, transformed by which exact command with which
exact flags, using which exact tool version, producing which exact bytes.

---

## 1. Tools you need, and what you can check without them

| check | needs |
|---|---|
| checksums (Check 1, 2, 5) | nothing beyond PowerShell, which ships with Windows |
| reading the recorded command lines (Check 3) | a text editor |
| re-running the programs (Check 6) | the built binaries, or a rebuild |
| rebuilding the C (Check 7) | Visual Studio 18 Professional, CMake, Ninja |
| rebuilding the Rust (Check 8) | a Rust toolchain (`rustup`) |

Checks 1–5 need no compiler at all.

---

## Check 1 — the files you have are the files that were measured

Every output file was hashed with SHA-256 when it was produced. To confirm your
copy is unaltered, in **PowerShell**, from the top of this repository:

```
Get-Content c-results\provenance\22-outputs.sha256 | ForEach-Object {
  $h,$f = $_ -split '  ',2
  $a = (Get-FileHash "c-results\outputs\$f" -Algorithm SHA256).Hash.ToLower()
  if ($a -ne $h) { "MISMATCH $f" }
}
"checked $((Get-Content c-results\provenance\22-outputs.sha256).Count) files"
```

**Expected:** no `MISMATCH` lines, and `checked 179 files`.

Repeat with `rust-results` in place of `c-results` (also 179 files).

On a machine with `sha256sum` (Git Bash, WSL, Linux, macOS) the same check is:

```
cd c-results/outputs && sha256sum -c ../provenance/22-outputs.sha256 | grep -v ': OK$'
```

**Expected:** no output at all.

---

## Check 2 — the sources in this repository are what was compiled

The C build read from an upstream copy of SUNDIALS 7.8.0 outside this
repository. So that you can audit it using the repository alone, every example
file was compared byte for byte against that upstream tree:

```
Get-Content differences\provenance\21-tree-identity.txt
```

**Expected**, at the end of that file:

```
identical : 370
different : 0
missing   : 0
```

If `different` were not 0, the sources you can read here would not be the
sources that were compiled, and nothing else in this repository could be
trusted. It is 0.

---

## Check 3 — what the compiler was actually told to do

This is the part that was missing in the first version of these documents, and
it is the part that matters most.

**The C.** Open `c-results/provenance/04-compile_commands.json`. It is produced
by CMake and contains one entry per source file, each with the *literal*
`cl.exe` command line. For example, `cvRoberts_dns.c` was compiled with:

```
cl.exe /nologo -DSUNDIALS_STATIC_DEFINE -D_CRT_SECURE_NO_WARNINGS
  -I<sundials>\include -I<build>\include
  -I<sundials>\src\sundials -I<build>\src\sundials
  /DWIN32 /D_WINDOWS /O2 /Ob2 /DNDEBUG -MD
  /Fo...\cvRoberts_dns.c.obj /Fd...\ /FS
  -c <sundials>\examples\cvode\serial\cvRoberts_dns.c
```

To pull any file's line out yourself:

```
python -c "import json;d=json.load(open('c-results/provenance/04-compile_commands.json'));print(next(e['command'] for e in d if e['file'].endswith('cvRoberts_dns.c')))"
```

`c-results/provenance/06-build-out.txt` is the build log with Ninja in verbose
mode, so it also contains every **link** command as executed, not just the
compiles. `c-results/provenance/01-configure-cmd.txt` holds the literal CMake
configure line, and `03-CMakeCache.txt` holds every option CMake resolved —
including the ones that were left at their defaults, which the configure line
does not show.

**The Rust.** `rust-results/provenance/02-build-out.txt` is `cargo build -v`
output, which prints every `rustc` invocation. The library was compiled with:

```
rustc --crate-name sundials_core --edition=2021 crates\sundials_core\src\lib.rs
  --crate-type lib --emit=dep-info,metadata,link
  -C opt-level=3 -C embed-bitcode=no -C strip=debuginfo
  -C target-feature=+fma
```

`-C target-feature=+fma` comes from `.cargo/config.toml`, reproduced verbatim
in `rust-results/provenance/03-cargo-config.txt`. Count how many compilations
carried it:

```
Select-String -Path rust-results\provenance\02-build-out.txt -Pattern 'target-feature=\+fma' | Measure-Object | Select-Object Count
```

**Expected:** 115.

**The four `*L` examples** are a special case, because they call LAPACK and no
LAPACK is installed. `c-results/provenance/10-lapacksub-cmd.txt` shows, for
each of them, *every line that differs* between the upstream source and the
source that was compiled — four lines each — plus the exact `cl.exe` line used.
Read it if you want to satisfy yourself that nothing else was changed.

---

## Check 4 — which tools produced this

```
Get-Content c-results\provenance\00-environment.txt
Get-Content rust-results\provenance\00-environment.txt
```

These record the operating system, the CPU, the UTC start and finish times, the
full path and version banner of `cl.exe` and `link.exe`, the CMake and Ninja
versions, the MSVC toolset and Windows SDK versions selected by `vcvars64.bat`,
and the complete `INCLUDE` and `LIB` search paths. The measured build used:

| | |
|---|---|
| compiler | `cl.exe` 19.51.36246 (MSVC toolset 14.51.36231), x64 |
| Windows SDK / UCRT | 10.0.28000.0 |
| CMake / Ninja | 4.1.2 / 1.13.2 |
| Rust | rustc/cargo 1.91.1, target `x86_64-pc-windows-msvc` |
| host | Windows 11 Pro for Workstations 10.0.26200.8655, Intel Core Ultra 9 275HX |

---

## Check 5 — the reference outputs are unmodified

The comparison judges both implementations against the `.out` files shipped in
the SUNDIALS 7.8.0 release. Their checksums are in
`differences/provenance/20-references.sha256` (199 files). Verify them the same
way as Check 1, against `examples/`.

---

## Check 6 — re-run the programs and get the same answers

The binaries are not committed (they are build products), but if you have built
them, or after doing Check 7 and Check 8:

```
python tools\example_matrix.py --all
python tools\example_report.py
```

This runs all 199 (example, argv) pairs on both sides, each in its own scratch
directory, and rewrites the tables. Then repeat Check 1: the checksums should
be unchanged.

This was done twice from independent builds, including a full `cargo clean`
rebuild, and all 358 output files were bit-for-bit identical both times.

---

## Check 7 — rebuild the C from scratch

Needs Visual Studio 18 Professional, CMake and Ninja.

```
tools\build_c_examples.cmd
tools\build_c_lapack_substituted.cmd
```

The first script deletes and recreates `logs\c-build`, then rewrites every file
in `c-results\provenance\`. Compare your regenerated
`04-compile_commands.json` against the committed one to confirm the flags match.

Expected: the configure and build both succeed, and `logs\c-build\bin` holds
109 `.exe` files (108 in-scope serial examples plus one manyvector example that
builds without MPI). The 20 KLU/SuperLU examples are absent because those
libraries are not installed — that is intentional and symmetric with the Rust
side.

---

## Check 8 — rebuild the Rust from scratch

Needs a Rust toolchain.

```
bash tools/build_rust_examples.sh
```

This runs `cargo clean` then `cargo build --release --workspace --examples -v`,
rewriting `rust-results/provenance/`. Expected: exit code 0, 0 warnings,
0 errors — the last lines of `rust-results/provenance/00-environment.txt`
report all three.

---

## What the evidence shows

Stated here so you know what you are checking. The reasoning is in
[`differences/ANALYSIS.md`](differences/ANALYSIS.md).

Over the 179 (example, argv) pairs both sides run:

| | count |
|---|---:|
| C and Rust print the same thing | 131 |
| they differ | 48 |
| …of those, Rust matches the SUNDIALS reference and the C does not | 41 |
| …of those, the C matches the reference and Rust does not | **0** |
| …of those, neither matches (the reference file is stale) | 7 |

Against the reference outputs shipped with SUNDIALS 7.8.0, the Rust port is
byte-identical on **153** of 179 and the MSVC C build on **112**.

The reason is recorded and measurable: the reference files were generated on a
Linux/glibc machine, and glibc's and Microsoft's maths libraries do not round
identically. A C program built here uses Microsoft's. The Rust port uses
neither — it carries its own implementations of `sin`, `cos`, `exp`, `log` and
the rest, checked bit-for-bit against glibc over 8,000,000 inputs per function
(`current_status.md` §2). So on this platform the Rust reproduces the published
results and a native C build cannot.

---

## Known limits of this evidence

* The 20 KLU/SuperLU examples were not built or run on either side, because
  those libraries are not installed. They are excluded symmetrically and
  listed in `c-results/EXCLUSIONS.md`.
* The MPI, OpenMP, GPU, PETSc, hypre, C++ and Fortran example directories are
  not covered at all, for the same reason. They are listed with their required
  backend in the same file.
* Comparisons strip carriage returns from both sides before comparing, because
  the MSVC C build writes CRLF line endings and the Rust port writes LF. That
  is a platform convention, not a numerical result — but it means "identical"
  in these tables means "identical after that one normalisation". The raw
  bytes are committed unmodified so you can confirm this yourself.
* Timing lines (`Total run time`, `CPU time`, `wall clock`) are removed from
  both sides before comparing, because they differ on every run of any program.
* The binaries themselves are not committed. Checksums for them are, in
  `*/provenance/21-binaries.sha256`, so a rebuild can be compared — though note
  that MSVC and rustc do not guarantee byte-identical binaries across rebuilds,
  so a hash mismatch there is not by itself evidence of a problem. The output
  checksums in Check 1 are the meaningful ones.
