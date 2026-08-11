# differences — summary

Generated 2026-08-11T01:07:34Z from commit `d3aa173`.

## C vs Rust, by class

| class | variants | meaning |
|---|---:|---|
| identical | 131 | same bytes after the timing filter |
| whitespace-only | 0 | every printed value identical, column spacing differs |
| content | 48 | at least one printed value differs |

## By example directory

| directory | variants | C==Rust | ws-only | content | Rust==ref | C==ref |
|---|---:|---:|---:|---:|---:|---:|
| `arkode/C_serial` | 78 | 54 | 0 | 24 | 63 | 42 |
| `cvode/serial` | 21 | 13 | 0 | 8 | 18 | 10 |
| `cvodes/serial` | 33 | 22 | 0 | 11 | 27 | 20 |
| `ida/serial` | 11 | 9 | 0 | 2 | 11 | 9 |
| `idas/serial` | 16 | 13 | 0 | 3 | 15 | 12 |
| `kinsol/serial` | 20 | 20 | 0 | 0 | 19 | 19 |
| **total** | **179** | **131** | **0** | **48** | **153** | **112** |

## Which side is right where they disagree

A disagreement is only a *defect* in one side if that side also disagrees with
the reference output shipped with SUNDIALS 7.8.0 — which was generated on a
glibc host by the upstream project.

| verdict | variants |
|---|---:|
| Rust matches the shipped reference, C does not | **41** |
| C matches the shipped reference, Rust does not | **0** |
| neither matches the shipped reference | **7** |
