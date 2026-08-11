#!/usr/bin/env python3
"""provenance_manifest.py — checksum every input, binary and output, and check
that the copy of the examples in this repository is the one that was compiled.

    python tools/provenance_manifest.py

Writes:
    c-results/provenance/20-input-sources.sha256      the .c files compiled
    c-results/provenance/21-binaries.sha256           the .exe files produced
    c-results/provenance/22-outputs.sha256            captured C outputs
    rust-results/provenance/20-input-sources.sha256   the .rs files compiled
    rust-results/provenance/21-binaries.sha256        the .exe files produced
    rust-results/provenance/22-outputs.sha256         captured Rust outputs
    differences/provenance/20-references.sha256       the shipped .out files
    differences/provenance/21-tree-identity.txt       repo examples/ vs the
                                                      upstream tree that was
                                                      actually compiled

Every line is `<sha256>  <path>`, the format `sha256sum -c` reads, so a reader
can verify the whole set with one command.

SPDX-License-Identifier: BSD-3-Clause
"""

import hashlib
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
UPSTREAM = Path(r"C:\Users\nsh\Developer\sundials-7.8.0")
C_BIN = ROOT / "logs" / "c-build" / "bin"
RUST_BIN = ROOT / "target" / "release" / "examples"

SERIAL = ["cvode/serial", "cvodes/serial", "kinsol/serial",
          "ida/serial", "idas/serial", "arkode/C_serial"]
CRATE_OF = {"cvode/serial": "cvode_rs", "cvodes/serial": "cvodes_rs",
            "kinsol/serial": "kinsol_rs", "ida/serial": "ida_rs",
            "idas/serial": "idas_rs", "arkode/C_serial": "arkode_rs"}


def sha(p: Path) -> str:
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def manifest(paths, out: Path, base: Path):
    out.parent.mkdir(parents=True, exist_ok=True)
    lines = []
    for p in sorted(paths):
        if p.is_file():
            lines.append(f"{sha(p)}  {p.relative_to(base).as_posix()}")
    out.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")
    print(f"{out.relative_to(ROOT).as_posix():52s} {len(lines):4d} files")
    return len(lines)


def main():
    # ---- inputs actually compiled -----------------------------------------
    c_src = [p for d in SERIAL for p in (UPSTREAM / "examples" / d).glob("*.c")]
    manifest(c_src, ROOT / "c-results/provenance/20-input-sources.sha256", UPSTREAM)

    rs_src = [p for d in SERIAL
              for p in (ROOT / "crates" / CRATE_OF[d] / "examples").glob("*.rs")]
    manifest(rs_src, ROOT / "rust-results/provenance/20-input-sources.sha256", ROOT)

    # ---- binaries ----------------------------------------------------------
    manifest(list(C_BIN.glob("*.exe")),
             ROOT / "c-results/provenance/21-binaries.sha256", C_BIN)
    manifest(list(RUST_BIN.glob("*.exe")),
             ROOT / "rust-results/provenance/21-binaries.sha256", RUST_BIN)

    # ---- captured outputs --------------------------------------------------
    manifest(list((ROOT / "c-results/outputs").glob("*.out")),
             ROOT / "c-results/provenance/22-outputs.sha256", ROOT / "c-results/outputs")
    manifest(list((ROOT / "rust-results/outputs").glob("*.out")),
             ROOT / "rust-results/provenance/22-outputs.sha256", ROOT / "rust-results/outputs")

    # ---- the shipped reference outputs ------------------------------------
    refs = [p for d in SERIAL for p in (ROOT / "examples" / d).glob("*.out")]
    manifest(refs, ROOT / "differences/provenance/20-references.sha256", ROOT / "examples")

    # ---- chain of custody: is the repo copy the thing that was compiled? ---
    out = ROOT / "differences/provenance/21-tree-identity.txt"
    lines = [
        "Chain of custody for the example sources",
        "=" * 72,
        "",
        "The C build compiled from the upstream tree:",
        f"    {UPSTREAM}\\examples\\",
        "The repository holds a copy at:",
        f"    {ROOT}\\examples\\",
        "",
        "If every file below is 'identical', the copy in this repository is",
        "byte-for-byte the source that was compiled, and a reader can audit the",
        "build using the repository alone.",
        "",
    ]
    same = diff = missing = 0
    for d in SERIAL:
        for up in sorted((UPSTREAM / "examples" / d).glob("*")):
            if not up.is_file():
                continue
            here = ROOT / "examples" / d / up.name
            if not here.exists():
                lines.append(f"MISSING    {d}/{up.name}")
                missing += 1
            elif sha(up) == sha(here):
                same += 1
            else:
                lines.append(f"DIFFERENT  {d}/{up.name}")
                diff += 1
    lines += [
        "",
        f"identical : {same}",
        f"different : {diff}",
        f"missing   : {missing}",
        "",
        "(Only differing or missing files are listed individually above.)",
    ]
    out.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")
    print(f"{out.relative_to(ROOT).as_posix():52s} identical={same} different={diff} missing={missing}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
