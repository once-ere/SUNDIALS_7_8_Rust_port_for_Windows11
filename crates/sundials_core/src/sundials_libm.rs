//! `sundials_libm` — a deterministic, host-independent libm.
//!
//! # Why this module exists
//!
//! The acceptance criterion of this project is byte-identical printed output
//! against the upstream SUNDIALS reference `.out` files, and those files were
//! generated on a **glibc** host. Rust's `f64::sin`, `f64::exp`, … are
//! documented as having *unspecified precision* and forward to whatever libm
//! the host provides. On this port's target — Windows on x86-64 — that is the
//! Microsoft UCRT, and `tools/libm_fingerprint_win.sh` shows it disagrees
//! with glibc on **every** transcendental the library and the examples
//! evaluate. Inside an adaptive integrator a one-ulp disagreement forks the
//! step-size trajectory and therefore the output.
//!
//! So the host libm is removed from the path entirely. Every routine here is
//! a translation of the implementation glibc 2.39 selects on x86-64, chosen
//! so that the *same* bits come back on any target, and each is measured
//! against a real glibc oracle by `tools/libm_differential_win.sh`.
//!
//! `SUNRpowerR`'s `pow` predates this module and still lives in
//! [`crate::sundials_math`]; it is the same idea, established first.
//!
//! # What glibc 2.39 actually runs on x86-64
//!
//! This matters for bit-exactness, because the x86-64 build is not always the
//! generic one. `sysdeps/x86_64/fpu/multiarch/` ifunc-dispatches a specific
//! set of double-precision routines to an **FMA-contracted** rebuild of the
//! generic source (`-mfma -mavx2 -ffp-contract=fast`) whenever the CPU
//! reports FMA:
//!
//! | routine | x86-64 build | consequence for this port |
//! |---|---|---|
//! | `exp`, `log`, `pow`, `asin`, `acos`, `atan`, `sin`, `cos`, `expm1`, `log1p` | FMA variant exists | expressions of the form `a*b + c` are fused; the port must use [`f64::mul_add`] in exactly the same places |
//! | `sinh`, `cosh`, `acosh` | **no FMA variant** — the generic build, on an SSE2 baseline | nothing is fused; the port must *not* use `mul_add`, even where it would be natural |
//!
//! Getting that split wrong is a 1-ulp error, which is the only kind that
//! matters here. See `POW_FMA_EXACTNESS.md` for how the same question was
//! settled for `pow`.
//!
//! # Provenance and licence
//!
//! Two different upstreams, and the distinction is deliberate:
//!
//! * [`exp`] and [`log`] are the ARM optimized-routines implementations,
//!   taken from **musl** (`src/math/exp.c`, `log.c` and their data tables),
//!   **MIT**. glibc ≥ 2.28 ships the same algorithm; using musl's copy keeps
//!   these two MIT, as the already-ported `pow` is.
//! * Everything else is translated from **glibc 2.39**, which is
//!   **LGPL-2.1-or-later**: `sin`/`cos` and `asin`/`acos`/`atan` from the IBM
//!   Accurate Mathematical Library, `expm1`/`log1p`/`sinh`/`cosh`/`acosh`
//!   from the fdlibm-derived files. Each file carries its own SPDX header.
//!
//! **This makes the repository a mixed-licence work**: the SUNDIALS
//! translation stays BSD-3-Clause, but the modules below are LGPL-2.1+ and a
//! binary linking them must satisfy that licence. See `NOTICE` §
//! "Deterministic libm". `tools/fetch_libm_sources.sh` downloads the upstream
//! C on demand; it is deliberately not committed.

pub mod exp;
pub mod log;
pub mod expm1;
pub mod log1p;
pub mod sincos;
pub mod atan;
pub mod asincos;
pub mod hyperbolic;

#[cfg(test)]
pub mod corpus;

pub use asincos::{acos, asin};
pub use atan::atan;
pub use exp::exp;
pub use expm1::expm1;
pub use hyperbolic::{acosh, cosh, sinh};
pub use log::log;
pub use log1p::log1p;
pub use sincos::{cos, sin};

#[cfg(test)]
mod tests {
    use super::corpus::{assert_bit_exact, Fn_};

    /* One differential test per routine. Each rebuilds the oracle's corpus
    from the shared splitmix64 recurrence, checks the argument hash the
    oracle recorded, and requires bit-for-bit agreement across every
    input. Without $SUNDIALS_LIBM_ORACLE_DIR they report "not run" and
    pass. Driver: tools/libm_differential_win.sh. */

    #[test]
    fn exp_vs_glibc_oracle() {
        assert_bit_exact(Fn_::Exp, super::exp);
    }
    #[test]
    fn log_vs_glibc_oracle() {
        assert_bit_exact(Fn_::Log, super::log);
    }
    #[test]
    fn expm1_vs_glibc_oracle() {
        assert_bit_exact(Fn_::Expm1, super::expm1);
    }
    #[test]
    fn log1p_vs_glibc_oracle() {
        assert_bit_exact(Fn_::Log1p, super::log1p);
    }
    #[test]
    fn sin_vs_glibc_oracle() {
        assert_bit_exact(Fn_::Sin, super::sin);
    }
    #[test]
    fn cos_vs_glibc_oracle() {
        assert_bit_exact(Fn_::Cos, super::cos);
    }
    #[test]
    fn atan_vs_glibc_oracle() {
        assert_bit_exact(Fn_::Atan, super::atan);
    }
    #[test]
    fn asin_vs_glibc_oracle() {
        assert_bit_exact(Fn_::Asin, super::asin);
    }
    #[test]
    fn acos_vs_glibc_oracle() {
        assert_bit_exact(Fn_::Acos, super::acos);
    }
    #[test]
    fn sinh_vs_glibc_oracle() {
        assert_bit_exact(Fn_::Sinh, super::sinh);
    }
    #[test]
    fn cosh_vs_glibc_oracle() {
        assert_bit_exact(Fn_::Cosh, super::cosh);
    }
    #[test]
    fn acosh_vs_glibc_oracle() {
        assert_bit_exact(Fn_::Acosh, super::acosh);
    }
}
