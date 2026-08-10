# evidence/windows-x86_64-ucrt

Raw artefacts behind every number in `current_status.md`, `README.md` and
Part A of `VERIFICATION.md`. Produced 2026-08-10 on the host described in
[`host.txt`](host.txt): Windows 11 Pro for Workstations 10.0.26200.8655
(25H2), Intel Core Ultra 9 275HX, `ucrtbase.dll` 10.0.26100.8521,
rustc/cargo 1.91.1, target `x86_64-pc-windows-msvc`.

| file | produced by | what it shows |
|---|---|---|
| `host.txt` | — | the measurement host, including the UCRT and the WSL2 guest glibc version |
| `summary.txt` | `SUNDIALS_C_TREE=… tools/verify_examples.sh all` | one line per (example, argv) variant: **125 IDENTICAL / 54 DIFF / 20 EXCLUDED**, 0 FAIL, 0 NO-REF |
| `classify_diffs.txt` | `SUNDIALS_C_TREE=… tools/classify_diffs.sh` | second pass over the divergent variants under `tr -s ' '` and `diff -w`: 14 of the 54 are whitespace-only |
| `pow_differential.log` | `tools/pow_differential_win.sh all` | the deterministic `pow`, built by `x86_64-pc-windows-msvc` and run natively, against a **glibc** oracle built and run inside the WSL2 guest: **0 mismatches over 5,900,000 domain and 20,000,000 unrestricted inputs** |
| `pow_host_differential.txt` | `cargo test -p sundials_core --lib pow_ -- --nocapture` | the same routine against the **host UCRT** `pow`: **4,926 of 5,900,000 domain inputs differ, worst gap 1 ulp** |
| `libm_fingerprint.txt` | `tools/libm_fingerprint_win.sh` | FNV-1a over 1,000,000 results per function, Windows vs the WSL2 glibc guest, from the same Rust source: `sqrt` matches, **every other probed function differs**, including the host `powf` |

The two `pow` corpora are 47 MB and 160 MB of raw `f64` bit patterns and are
not committed; `tools/pow_differential_win.sh` regenerates them from the
splitmix64 recurrence both sides share.

The sibling directory [`../linux-x86_64-glibc239/`](../linux-x86_64-glibc239/)
holds the Linux port's artefacts, including the pristine-C comparison that
proved the 26 divergences this port inherits are reference-side. No
equivalent pristine-C build has been made on Windows — see
`current_status.md` §6 item 1.
