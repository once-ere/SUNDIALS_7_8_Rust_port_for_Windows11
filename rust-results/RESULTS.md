# rust-results — per-variant results

Rust port, release build, 2026-08-11T01:07:34Z. `same` / `ws-only` / `content`
describe this build's output against the reference `.out` shipped with
SUNDIALS 7.8.0, after removing timing lines from both sides.

| example | argv | dir | status | solver error | bytes | vs shipped ref | diff lines | output file |
|---|---|---|---|---|---|---|---|---|
| `cvAdvDiff_bnd` |  | cvode/serial | ran |  | 848 | same |  | [`cvAdvDiff_bnd.out`](outputs/cvAdvDiff_bnd.out) |
| `cvAnalytic_mels` |  | cvode/serial | ran |  | 770 | same |  | [`cvAnalytic_mels.out`](outputs/cvAnalytic_mels.out) |
| `cvDirectDemo_ls` |  | cvode/serial | ran |  | 17673 | same |  | [`cvDirectDemo_ls.out`](outputs/cvDirectDemo_ls.out) |
| `cvDisc_dns` |  | cvode/serial | ran |  | 3360 | same |  | [`cvDisc_dns.out`](outputs/cvDisc_dns.out) |
| `cvDiurnal_kry_bp` |  | cvode/serial | ran |  | 6047 | same |  | [`cvDiurnal_kry_bp.out`](outputs/cvDiurnal_kry_bp.out) |
| `cvDiurnal_kry` |  | cvode/serial | ran |  | 2860 | same |  | [`cvDiurnal_kry.out`](outputs/cvDiurnal_kry.out) |
| `cvKrylovDemo_ls` |  | cvode/serial | ran |  | 11712 | same |  | [`cvKrylovDemo_ls.out`](outputs/cvKrylovDemo_ls.out) |
| `cvKrylovDemo_ls` | `1` | cvode/serial | ran |  | 11712 | same |  | [`cvKrylovDemo_ls_1.out`](outputs/cvKrylovDemo_ls_1.out) |
| `cvKrylovDemo_ls` | `2` | cvode/serial | ran |  | 11712 | same |  | [`cvKrylovDemo_ls_2.out`](outputs/cvKrylovDemo_ls_2.out) |
| `cvKrylovDemo_prec` |  | cvode/serial | ran |  | 26471 | same |  | [`cvKrylovDemo_prec.out`](outputs/cvKrylovDemo_prec.out) |
| `cvParticle_dns` |  | cvode/serial | ran |  | 885 | same |  | [`cvParticle_dns.out`](outputs/cvParticle_dns.out) |
| `cvPendulum_dns` |  | cvode/serial | ran |  | 1900 | content | 10 | [`cvPendulum_dns.out`](outputs/cvPendulum_dns.out) |
| `cvRoberts_dns` |  | cvode/serial | ran |  | 2217 | same |  | [`cvRoberts_dns.out`](outputs/cvRoberts_dns.out) |
| `cvRoberts_dns_constraints` |  | cvode/serial | ran |  | 1261 | same |  | [`cvRoberts_dns_constraints.out`](outputs/cvRoberts_dns_constraints.out) |
| `cvRoberts_dns_negsol` |  | cvode/serial | ran |  | 2409 | ws-only | 2 | [`cvRoberts_dns_negsol.out`](outputs/cvRoberts_dns_negsol.out) |
| `cvRoberts_dns_uw` |  | cvode/serial | ran |  | 1261 | same |  | [`cvRoberts_dns_uw.out`](outputs/cvRoberts_dns_uw.out) |
| `cvRocket_dns` |  | cvode/serial | ran |  | 4212 | same |  | [`cvRocket_dns.out`](outputs/cvRocket_dns.out) |
| `cvVdp_auto_nls` |  | cvode/serial | ran |  | 2403 | same |  | [`cvVdp_auto_nls.out`](outputs/cvVdp_auto_nls.out) |
| `cvKrylovDemo_ls` | `0 1` | cvode/serial | ran |  | 2472 | same |  | [`cvKrylovDemo_ls_0_1.out`](outputs/cvKrylovDemo_ls_0_1.out) |
| `cvAdvDiff_bndL` |  | cvode/serial | ran |  | 848 | same |  | [`cvAdvDiff_bndL.out`](outputs/cvAdvDiff_bndL.out) |
| `cvRoberts_dnsL` |  | cvode/serial | ran |  | 1261 | content | 16 | [`cvRoberts_dnsL.out`](outputs/cvRoberts_dnsL.out) |
| `cvRoberts_block_klu` |  | cvode/serial | excluded(klu) |  | 0 | — |  | — |
| `cvRoberts_klu` |  | cvode/serial | excluded(klu) |  | 0 | — |  | — |
| `cvRoberts_sps` |  | cvode/serial | excluded(superlu) |  | 0 | — |  | — |
| `cvsAdvDiff_ASAi_bnd` |  | cvodes/serial | ran |  | 273 | same |  | [`cvsAdvDiff_ASAi_bnd.out`](outputs/cvsAdvDiff_ASAi_bnd.out) |
| `cvsAdvDiff_FSA_non` | `-sensi sim t` | cvodes/serial | ran |  | 3262 | same |  | [`cvsAdvDiff_FSA_non_-sensi_sim_t.out`](outputs/cvsAdvDiff_FSA_non_-sensi_sim_t.out) |
| `cvsAdvDiff_FSA_non` | `-sensi stg t` | cvodes/serial | ran |  | 3259 | same |  | [`cvsAdvDiff_FSA_non_-sensi_stg_t.out`](outputs/cvsAdvDiff_FSA_non_-sensi_stg_t.out) |
| `cvsAdvDiff_bnd` |  | cvodes/serial | ran |  | 850 | same |  | [`cvsAdvDiff_bnd.out`](outputs/cvsAdvDiff_bnd.out) |
| `cvsAnalytic_mels` |  | cvodes/serial | ran |  | 770 | same |  | [`cvsAnalytic_mels.out`](outputs/cvsAnalytic_mels.out) |
| `cvsAnalytic_mels` | `cvodes.max_order 3` | cvodes/serial | ran |  | 771 | same |  | [`cvsAnalytic_mels_cvodes.max_order_3.out`](outputs/cvsAnalytic_mels_cvodes.max_order_3.out) |
| `cvsDirectDemo_ls` |  | cvodes/serial | ran |  | 17713 | same |  | [`cvsDirectDemo_ls.out`](outputs/cvsDirectDemo_ls.out) |
| `cvsDiurnal_FSA_kry` | `-sensi sim t` | cvodes/serial | ran |  | 8944 | same |  | [`cvsDiurnal_FSA_kry_-sensi_sim_t.out`](outputs/cvsDiurnal_FSA_kry_-sensi_sim_t.out) |
| `cvsDiurnal_FSA_kry` | `-sensi stg t` | cvodes/serial | ran |  | 8941 | same |  | [`cvsDiurnal_FSA_kry_-sensi_stg_t.out`](outputs/cvsDiurnal_FSA_kry_-sensi_stg_t.out) |
| `cvsDiurnal_kry` |  | cvodes/serial | ran |  | 2860 | same |  | [`cvsDiurnal_kry.out`](outputs/cvsDiurnal_kry.out) |
| `cvsDiurnal_kry_bp` |  | cvodes/serial | ran |  | 6047 | same |  | [`cvsDiurnal_kry_bp.out`](outputs/cvsDiurnal_kry_bp.out) |
| `cvsFoodWeb_ASAi_kry` |  | cvodes/serial | ran |  | 991 | same |  | [`cvsFoodWeb_ASAi_kry.out`](outputs/cvsFoodWeb_ASAi_kry.out) |
| `cvsFoodWeb_ASAp_kry` |  | cvodes/serial | ran |  | 961 | same |  | [`cvsFoodWeb_ASAp_kry.out`](outputs/cvsFoodWeb_ASAp_kry.out) |
| `cvsHessian_ASA_FSA` |  | cvodes/serial | ran |  | 2307 | same |  | [`cvsHessian_ASA_FSA.out`](outputs/cvsHessian_ASA_FSA.out) |
| `cvsKrylovDemo_ls` |  | cvodes/serial | ran |  | 11712 | content | 25 | [`cvsKrylovDemo_ls.out`](outputs/cvsKrylovDemo_ls.out) |
| `cvsKrylovDemo_ls` | `1` | cvodes/serial | ran |  | 11712 | content | 25 | [`cvsKrylovDemo_ls_1.out`](outputs/cvsKrylovDemo_ls_1.out) |
| `cvsKrylovDemo_ls` | `2` | cvodes/serial | ran |  | 11712 | content | 25 | [`cvsKrylovDemo_ls_2.out`](outputs/cvsKrylovDemo_ls_2.out) |
| `cvsKrylovDemo_prec` |  | cvodes/serial | ran |  | 26472 | same |  | [`cvsKrylovDemo_prec.out`](outputs/cvsKrylovDemo_prec.out) |
| `cvsLotkaVolterra_ASA` |  | cvodes/serial | ran |  | 405 | same |  | [`cvsLotkaVolterra_ASA.out`](outputs/cvsLotkaVolterra_ASA.out) |
| `cvsParticle_dns` |  | cvodes/serial | ran |  | 885 | same |  | [`cvsParticle_dns.out`](outputs/cvsParticle_dns.out) |
| `cvsPendulum_dns` |  | cvodes/serial | ran |  | 1900 | content | 10 | [`cvsPendulum_dns.out`](outputs/cvsPendulum_dns.out) |
| `cvsRoberts_ASAi_dns` |  | cvodes/serial | ran |  | 5336 | same |  | [`cvsRoberts_ASAi_dns.out`](outputs/cvsRoberts_ASAi_dns.out) |
| `cvsRoberts_ASAi_dns_constraints` |  | cvodes/serial | ran |  | 1879 | same |  | [`cvsRoberts_ASAi_dns_constraints.out`](outputs/cvsRoberts_ASAi_dns_constraints.out) |
| `cvsRoberts_FSA_dns` | `-sensi sim t` | cvodes/serial | ran |  | 6280 | same |  | [`cvsRoberts_FSA_dns_-sensi_sim_t.out`](outputs/cvsRoberts_FSA_dns_-sensi_sim_t.out) |
| `cvsRoberts_FSA_dns` | `-sensi stg1 t` | cvodes/serial | ran |  | 6513 | same |  | [`cvsRoberts_FSA_dns_-sensi_stg1_t.out`](outputs/cvsRoberts_FSA_dns_-sensi_stg1_t.out) |
| `cvsRoberts_FSA_dns_Switch` |  | cvodes/serial | ran |  | 1849 | same |  | [`cvsRoberts_FSA_dns_Switch.out`](outputs/cvsRoberts_FSA_dns_Switch.out) |
| `cvsRoberts_FSA_dns_constraints` | `-sensi stg1 t` | cvodes/serial | ran |  | 5277 | same |  | [`cvsRoberts_FSA_dns_constraints_-sensi_stg1_t.out`](outputs/cvsRoberts_FSA_dns_constraints_-sensi_stg1_t.out) |
| `cvsRoberts_dns` |  | cvodes/serial | ran |  | 2217 | same |  | [`cvsRoberts_dns.out`](outputs/cvsRoberts_dns.out) |
| `cvsRoberts_dns_constraints` |  | cvodes/serial | ran |  | 1261 | same |  | [`cvsRoberts_dns_constraints.out`](outputs/cvsRoberts_dns_constraints.out) |
| `cvsRoberts_dns_uw` |  | cvodes/serial | ran |  | 1261 | same |  | [`cvsRoberts_dns_uw.out`](outputs/cvsRoberts_dns_uw.out) |
| `cvsKrylovDemo_ls` | `0 1` | cvodes/serial | ran |  | 11712 | content | 738 | [`cvsKrylovDemo_ls_0_1.out`](outputs/cvsKrylovDemo_ls_0_1.out) |
| `cvsAdvDiff_bndL` |  | cvodes/serial | ran |  | 863 | same |  | [`cvsAdvDiff_bndL.out`](outputs/cvsAdvDiff_bndL.out) |
| `cvsRoberts_dnsL` |  | cvodes/serial | ran |  | 1261 | content | 32 | [`cvsRoberts_dnsL.out`](outputs/cvsRoberts_dnsL.out) |
| `cvsRoberts_ASAi_klu` |  | cvodes/serial | excluded(klu) |  | 0 | — |  | — |
| `cvsRoberts_FSA_klu` | `-sensi stg1 t` | cvodes/serial | excluded(klu) |  | 0 | — |  | — |
| `cvsRoberts_klu` |  | cvodes/serial | excluded(klu) |  | 0 | — |  | — |
| `cvsRoberts_ASAi_sps` |  | cvodes/serial | excluded(superlu) |  | 0 | — |  | — |
| `cvsRoberts_FSA_sps` | `-sensi stg1 t` | cvodes/serial | excluded(superlu) |  | 0 | — |  | — |
| `cvsRoberts_sps` |  | cvodes/serial | excluded(superlu) |  | 0 | — |  | — |
| `kinAnalytic_fp` |  | kinsol/serial | ran |  | 708 | same |  | [`kinAnalytic_fp.out`](outputs/kinAnalytic_fp.out) |
| `kinAnalytic_fp` | `--damping_fp 0.5` | kinsol/serial | ran |  | 717 | same |  | [`kinAnalytic_fp_--damping_fp_0.5.out`](outputs/kinAnalytic_fp_--damping_fp_0.5.out) |
| `kinAnalytic_fp` | `--damping_fn` | kinsol/serial | ran |  | 714 | same |  | [`kinAnalytic_fp_--damping_fn.out`](outputs/kinAnalytic_fp_--damping_fn.out) |
| `kinAnalytic_fp` | `--m_aa 2` | kinsol/serial | ran |  | 707 | same |  | [`kinAnalytic_fp_--m_aa_2.out`](outputs/kinAnalytic_fp_--m_aa_2.out) |
| `kinAnalytic_fp` | `--m_aa 2 --delay_aa 2` | kinsol/serial | ran |  | 708 | same |  | [`kinAnalytic_fp_--m_aa_2_--delay_aa_2.out`](outputs/kinAnalytic_fp_--m_aa_2_--delay_aa_2.out) |
| `kinAnalytic_fp` | `--m_aa 2 --damping_aa 0.5` | kinsol/serial | ran |  | 722 | same |  | [`kinAnalytic_fp_--m_aa_2_--damping_aa_0.5.out`](outputs/kinAnalytic_fp_--m_aa_2_--damping_aa_0.5.out) |
| `kinAnalytic_fp` | `--m_aa 2 --damping_fn` | kinsol/serial | ran |  | 711 | same |  | [`kinAnalytic_fp_--m_aa_2_--damping_fn.out`](outputs/kinAnalytic_fp_--m_aa_2_--damping_fn.out) |
| `kinAnalytic_fp` | `--m_aa 3 --depth_fn` | kinsol/serial | ran |  | 707 | same |  | [`kinAnalytic_fp_--m_aa_3_--depth_fn.out`](outputs/kinAnalytic_fp_--m_aa_3_--depth_fn.out) |
| `kinAnalytic_fp` | `--m_aa 2 --orth_aa 1` | kinsol/serial | ran |  | 707 | same |  | [`kinAnalytic_fp_--m_aa_2_--orth_aa_1.out`](outputs/kinAnalytic_fp_--m_aa_2_--orth_aa_1.out) |
| `kinAnalytic_fp` | `--m_aa 2 --orth_aa 2` | kinsol/serial | ran |  | 707 | same |  | [`kinAnalytic_fp_--m_aa_2_--orth_aa_2.out`](outputs/kinAnalytic_fp_--m_aa_2_--orth_aa_2.out) |
| `kinAnalytic_fp` | `--m_aa 2 --orth_aa 3` | kinsol/serial | ran |  | 707 | same |  | [`kinAnalytic_fp_--m_aa_2_--orth_aa_3.out`](outputs/kinAnalytic_fp_--m_aa_2_--orth_aa_3.out) |
| `kinFerTron_dns` |  | kinsol/serial | ran |  | 1503 | same |  | [`kinFerTron_dns.out`](outputs/kinFerTron_dns.out) |
| `kinFoodWeb_kry` |  | kinsol/serial | ran |  | 789 | same |  | [`kinFoodWeb_kry.out`](outputs/kinFoodWeb_kry.out) |
| `kinKrylovDemo_ls` |  | kinsol/serial | ran |  | 3420 | same |  | [`kinKrylovDemo_ls.out`](outputs/kinKrylovDemo_ls.out) |
| `kinLaplace_bnd` |  | kinsol/serial | ran |  | 1816 | same |  | [`kinLaplace_bnd.out`](outputs/kinLaplace_bnd.out) |
| `kinLaplace_picard_bnd` |  | kinsol/serial | ran |  | 1762 | same |  | [`kinLaplace_picard_bnd.out`](outputs/kinLaplace_picard_bnd.out) |
| `kinLaplace_picard_kry` |  | kinsol/serial | ran |  | 1761 | same |  | [`kinLaplace_picard_kry.out`](outputs/kinLaplace_picard_kry.out) |
| `kinRoberts_fp` |  | kinsol/serial | ran |  | 546 | same |  | [`kinRoberts_fp.out`](outputs/kinRoberts_fp.out) |
| `kinRoberts_fp` | `kinsol.m_aa 1` | kinsol/serial | ran |  | 546 | same |  | [`kinRoberts_fp_kinsol.m_aa_1.out`](outputs/kinRoberts_fp_kinsol.m_aa_1.out) |
| `kinRoboKin_dns` |  | kinsol/serial | ran |  | 1483 | ws-only | 32 | [`kinRoboKin_dns.out`](outputs/kinRoboKin_dns.out) |
| `kinFerTron_klu` |  | kinsol/serial | excluded(klu) |  | 0 | — |  | — |
| `kinRoboKin_slu` |  | kinsol/serial | excluded(superlu) |  | 0 | — |  | — |
| `idaAnalytic_mels` |  | ida/serial | ran |  | 756 | same |  | [`idaAnalytic_mels.out`](outputs/idaAnalytic_mels.out) |
| `idaAnalytic_mels` | `ida.scalar_tolerances 1e-3 1e-8` | ida/serial | ran |  | 751 | same |  | [`idaAnalytic_mels_ida.scalar_tolerances_1e-3_1e-8.out`](outputs/idaAnalytic_mels_ida.scalar_tolerances_1e-3_1e-8.out) |
| `idaFoodWeb_bnd` |  | ida/serial | ran |  | 1540 | same |  | [`idaFoodWeb_bnd.out`](outputs/idaFoodWeb_bnd.out) |
| `idaFoodWeb_kry` |  | ida/serial | ran |  | 1516 | same |  | [`idaFoodWeb_kry.out`](outputs/idaFoodWeb_kry.out) |
| `idaHeat2D_bnd` |  | ida/serial | ran |  | 1465 | same |  | [`idaHeat2D_bnd.out`](outputs/idaHeat2D_bnd.out) |
| `idaHeat2D_kry` |  | ida/serial | ran |  | 2646 | same |  | [`idaHeat2D_kry.out`](outputs/idaHeat2D_kry.out) |
| `idaKrylovDemo_ls` |  | ida/serial | ran |  | 4763 | same |  | [`idaKrylovDemo_ls.out`](outputs/idaKrylovDemo_ls.out) |
| `idaKrylovDemo_ls` | `1` | ida/serial | ran |  | 4763 | same |  | [`idaKrylovDemo_ls_1.out`](outputs/idaKrylovDemo_ls_1.out) |
| `idaKrylovDemo_ls` | `2` | ida/serial | ran |  | 4763 | same |  | [`idaKrylovDemo_ls_2.out`](outputs/idaKrylovDemo_ls_2.out) |
| `idaRoberts_dns` |  | ida/serial | ran |  | 2684 | same |  | [`idaRoberts_dns.out`](outputs/idaRoberts_dns.out) |
| `idaSlCrank_dns` |  | ida/serial | ran |  | 3551 | same |  | [`idaSlCrank_dns.out`](outputs/idaSlCrank_dns.out) |
| `idaHeat2D_klu` |  | ida/serial | excluded(klu) |  | 0 | — |  | — |
| `idaRoberts_klu` |  | ida/serial | excluded(klu) |  | 0 | — |  | — |
| `idaRoberts_sps` |  | ida/serial | excluded(superlu) |  | 0 | — |  | — |
| `idasAkzoNob_ASAi_dns` |  | idas/serial | ran |  | 567 | content | 3 | [`idasAkzoNob_ASAi_dns.out`](outputs/idasAkzoNob_ASAi_dns.out) |
| `idasAkzoNob_dns` |  | idas/serial | ran |  | 3036 | same |  | [`idasAkzoNob_dns.out`](outputs/idasAkzoNob_dns.out) |
| `idasAnalytic_mels` |  | idas/serial | ran |  | 842 | same |  | [`idasAnalytic_mels.out`](outputs/idasAnalytic_mels.out) |
| `idasAnalytic_mels` | `idas.init_step 1e-5` | idas/serial | ran |  | 842 | same |  | [`idasAnalytic_mels_idas.init_step_1e-5.out`](outputs/idasAnalytic_mels_idas.init_step_1e-5.out) |
| `idasFoodWeb_bnd` |  | idas/serial | ran |  | 1541 | same |  | [`idasFoodWeb_bnd.out`](outputs/idasFoodWeb_bnd.out) |
| `idasHeat2D_bnd` |  | idas/serial | ran |  | 1478 | same |  | [`idasHeat2D_bnd.out`](outputs/idasHeat2D_bnd.out) |
| `idasHeat2D_kry` |  | idas/serial | ran |  | 2665 | same |  | [`idasHeat2D_kry.out`](outputs/idasHeat2D_kry.out) |
| `idasHessian_ASA_FSA` |  | idas/serial | ran |  | 1258 | same |  | [`idasHessian_ASA_FSA.out`](outputs/idasHessian_ASA_FSA.out) |
| `idasKrylovDemo_ls` |  | idas/serial | ran |  | 4820 | same |  | [`idasKrylovDemo_ls.out`](outputs/idasKrylovDemo_ls.out) |
| `idasKrylovDemo_ls` | `1` | idas/serial | ran |  | 4820 | same |  | [`idasKrylovDemo_ls_1.out`](outputs/idasKrylovDemo_ls_1.out) |
| `idasKrylovDemo_ls` | `2` | idas/serial | ran |  | 4820 | same |  | [`idasKrylovDemo_ls_2.out`](outputs/idasKrylovDemo_ls_2.out) |
| `idasRoberts_ASAi_dns` |  | idas/serial | ran |  | 4644 | same |  | [`idasRoberts_ASAi_dns.out`](outputs/idasRoberts_ASAi_dns.out) |
| `idasRoberts_FSA_dns` | `-sensi stg t` | idas/serial | ran |  | 7142 | same |  | [`idasRoberts_FSA_dns_-sensi_stg_t.out`](outputs/idasRoberts_FSA_dns_-sensi_stg_t.out) |
| `idasRoberts_dns` |  | idas/serial | ran |  | 2692 | same |  | [`idasRoberts_dns.out`](outputs/idasRoberts_dns.out) |
| `idasSlCrank_dns` |  | idas/serial | ran |  | 2546 | same |  | [`idasSlCrank_dns.out`](outputs/idasSlCrank_dns.out) |
| `idasSlCrank_FSA_dns` |  | idas/serial | ran |  | 1027 | same |  | [`idasSlCrank_FSA_dns.out`](outputs/idasSlCrank_FSA_dns.out) |
| `idasRoberts_ASAi_klu` |  | idas/serial | excluded(klu) |  | 0 | — |  | — |
| `idasRoberts_FSA_klu` | `-sensi stg t` | idas/serial | excluded(klu) |  | 0 | — |  | — |
| `idasRoberts_klu` |  | idas/serial | excluded(klu) |  | 0 | — |  | — |
| `idasRoberts_ASAi_sps` |  | idas/serial | excluded(superlu) |  | 0 | — |  | — |
| `idasRoberts_FSA_sps` | `-sensi stg t` | idas/serial | excluded(superlu) |  | 0 | — |  | — |
| `idasRoberts_sps` |  | idas/serial | excluded(superlu) |  | 0 | — |  | — |
| `ark_analytic` |  | arkode/C_serial | ran |  | 2021 | same |  | [`ark_analytic.out`](outputs/ark_analytic.out) |
| `ark_analytic` | `arkode.scalar_tolerances 1e-6 1e-8 arkode.table_names ARKODE_ESDIRK547L2SA_7_4_5 ARKODE_ERK_NONE` | arkode/C_serial | ran |  | 2021 | same |  | [`ark_analytic_arkode.scalar_tolerances_1e-6_1e-8_arkode.table_names_ARKODE_ESDIRK547L2SA_7_4_5_ARKODE_ERK_NONE.out`](outputs/ark_analytic_arkode.scalar_tolerances_1e-6_1e-8_arkode.table_names_ARKODE_ESDIRK547L2SA_7_4_5_ARKODE_ERK_NONE.out) |
| `ark_advection_diffusion_reaction_splitting` |  | arkode/C_serial | ran |  | 3288 | same |  | [`ark_advection_diffusion_reaction_splitting.out`](outputs/ark_advection_diffusion_reaction_splitting.out) |
| `ark_analytic_lsrk` |  | arkode/C_serial | ran |  | 1143 | same |  | [`ark_analytic_lsrk.out`](outputs/ark_analytic_lsrk.out) |
| `ark_analytic_lsrk_varjac` |  | arkode/C_serial | ran |  | 1302 | same |  | [`ark_analytic_lsrk_varjac.out`](outputs/ark_analytic_lsrk_varjac.out) |
| `ark_analytic_lsrk_domeigest` |  | arkode/C_serial | ran |  | 1384 | same |  | [`ark_analytic_lsrk_domeigest.out`](outputs/ark_analytic_lsrk_domeigest.out) |
| `ark_analytic_lsrk_domeigest` | `arkid.dom_eig_est_init_preprocess_iters 1 sundomeigestimator.max_iters 1` | arkode/C_serial | ran |  | 1373 | same |  | [`ark_analytic_lsrk_domeigest_arkid.dom_eig_est_init_preprocess_iters_1_sundomeigestimator.max_iters_1.out`](outputs/ark_analytic_lsrk_domeigest_arkid.dom_eig_est_init_preprocess_iters_1_sundomeigestimator.max_iters_1.out) |
| `ark_analytic_mels` |  | arkode/C_serial | ran |  | 801 | same |  | [`ark_analytic_mels.out`](outputs/ark_analytic_mels.out) |
| `ark_analytic_nonlin` |  | arkode/C_serial | ran |  | 886 | same |  | [`ark_analytic_nonlin.out`](outputs/ark_analytic_nonlin.out) |
| `ark_analytic_partitioned` | `forcing` | arkode/C_serial | ran |  | 1673 | ws-only | 84 | [`ark_analytic_partitioned_forcing.out`](outputs/ark_analytic_partitioned_forcing.out) |
| `ark_analytic_partitioned` | `splitting` | arkode/C_serial | ran |  | 1673 | ws-only | 84 | [`ark_analytic_partitioned_splitting.out`](outputs/ark_analytic_partitioned_splitting.out) |
| `ark_analytic_partitioned` | `splitting ARKODE_SPLITTING_BEST_2_2_2` | arkode/C_serial | ran |  | 1750 | ws-only | 84 | [`ark_analytic_partitioned_splitting_ARKODE_SPLITTING_BEST_2_2_2.out`](outputs/ark_analytic_partitioned_splitting_ARKODE_SPLITTING_BEST_2_2_2.out) |
| `ark_analytic_partitioned` | `splitting ARKODE_SPLITTING_RUTH_3_3_2` | arkode/C_serial | ran |  | 1754 | ws-only | 84 | [`ark_analytic_partitioned_splitting_ARKODE_SPLITTING_RUTH_3_3_2.out`](outputs/ark_analytic_partitioned_splitting_ARKODE_SPLITTING_RUTH_3_3_2.out) |
| `ark_analytic_partitioned` | `splitting ARKODE_SPLITTING_YOSHIDA_8_6_2` | arkode/C_serial | ran |  | 1759 | ws-only | 84 | [`ark_analytic_partitioned_splitting_ARKODE_SPLITTING_YOSHIDA_8_6_2.out`](outputs/ark_analytic_partitioned_splitting_ARKODE_SPLITTING_YOSHIDA_8_6_2.out) |
| `ark_analytic_ssprk` |  | arkode/C_serial | ran |  | 990 | same |  | [`ark_analytic_ssprk.out`](outputs/ark_analytic_ssprk.out) |
| `ark_brusselator_1D_mri` |  | arkode/C_serial | ran |  | 5681 | same |  | [`ark_brusselator_1D_mri.out`](outputs/ark_brusselator_1D_mri.out) |
| `ark_brusselator_fp` |  | arkode/C_serial | ran |  | 1107 | same |  | [`ark_brusselator_fp.out`](outputs/ark_brusselator_fp.out) |
| `ark_brusselator_lsrk_domeigest` |  | arkode/C_serial | ran |  | 1641 | same |  | [`ark_brusselator_lsrk_domeigest.out`](outputs/ark_brusselator_lsrk_domeigest.out) |
| `ark_brusselator_lsrk_externaldomeigest` |  | arkode/C_serial | ran |  | 1570 | same |  | [`ark_brusselator_lsrk_externaldomeigest.out`](outputs/ark_brusselator_lsrk_externaldomeigest.out) |
| `ark_brusselator_mri` |  | arkode/C_serial | ran |  | 1443 | same |  | [`ark_brusselator_mri.out`](outputs/ark_brusselator_mri.out) |
| `ark_brusselator` |  | arkode/C_serial | ran |  | 1320 | same |  | [`ark_brusselator.out`](outputs/ark_brusselator.out) |
| `ark_brusselator1D_imexmri` | `0 0.001` | arkode/C_serial | ran |  | 1299 | same |  | [`ark_brusselator1D_imexmri_0_0.001.out`](outputs/ark_brusselator1D_imexmri_0_0.001.out) |
| `ark_brusselator1D_imexmri` | `2 0.001` | arkode/C_serial | ran |  | 1328 | same |  | [`ark_brusselator1D_imexmri_2_0.001.out`](outputs/ark_brusselator1D_imexmri_2_0.001.out) |
| `ark_brusselator1D_imexmri` | `3 0.001` | arkode/C_serial | ran |  | 1423 | same |  | [`ark_brusselator1D_imexmri_3_0.001.out`](outputs/ark_brusselator1D_imexmri_3_0.001.out) |
| `ark_brusselator1D_imexmri` | `4 0.001` | arkode/C_serial | ran |  | 1334 | same |  | [`ark_brusselator1D_imexmri_4_0.001.out`](outputs/ark_brusselator1D_imexmri_4_0.001.out) |
| `ark_brusselator1D_imexmri` | `5 0.001` | arkode/C_serial | ran |  | 1430 | same |  | [`ark_brusselator1D_imexmri_5_0.001.out`](outputs/ark_brusselator1D_imexmri_5_0.001.out) |
| `ark_brusselator1D_imexmri` | `6 0.001` | arkode/C_serial | ran |  | 1336 | same |  | [`ark_brusselator1D_imexmri_6_0.001.out`](outputs/ark_brusselator1D_imexmri_6_0.001.out) |
| `ark_brusselator1D_imexmri` | `7 0.001` | arkode/C_serial | ran |  | 1440 | same |  | [`ark_brusselator1D_imexmri_7_0.001.out`](outputs/ark_brusselator1D_imexmri_7_0.001.out) |
| `ark_brusselator1D` |  | arkode/C_serial | ran |  | 5665 | same |  | [`ark_brusselator1D.out`](outputs/ark_brusselator1D.out) |
| `ark_conserved_exp_entropy_ark` | `1 0` | arkode/C_serial | ran |  | 2938 | same |  | [`ark_conserved_exp_entropy_ark_1_0.out`](outputs/ark_conserved_exp_entropy_ark_1_0.out) |
| `ark_conserved_exp_entropy_ark` | `1 1` | arkode/C_serial | ran |  | 2209 | content | 1 | [`ark_conserved_exp_entropy_ark_1_1.out`](outputs/ark_conserved_exp_entropy_ark_1_1.out) |
| `ark_conserved_exp_entropy_erk` | `1` | arkode/C_serial | ran |  | 2762 | same |  | [`ark_conserved_exp_entropy_erk_1.out`](outputs/ark_conserved_exp_entropy_erk_1.out) |
| `ark_damped_harmonic_symplectic` |  | arkode/C_serial | ran |  | 969 | ws-only | 26 | [`ark_damped_harmonic_symplectic.out`](outputs/ark_damped_harmonic_symplectic.out) |
| `ark_dissipated_exp_entropy` | `1 0` | arkode/C_serial | ran |  | 4236 | same |  | [`ark_dissipated_exp_entropy_1_0.out`](outputs/ark_dissipated_exp_entropy_1_0.out) |
| `ark_dissipated_exp_entropy` | `1 1` | arkode/C_serial | ran |  | 2938 | content | 1 | [`ark_dissipated_exp_entropy_1_1.out`](outputs/ark_dissipated_exp_entropy_1_1.out) |
| `ark_harmonic_symplectic` |  | arkode/C_serial | ran |  | 1258 | ws-only | 26 | [`ark_harmonic_symplectic.out`](outputs/ark_harmonic_symplectic.out) |
| `ark_heat1D_adapt` |  | arkode/C_serial | ran |  | 6365 | same |  | [`ark_heat1D_adapt.out`](outputs/ark_heat1D_adapt.out) |
| `ark_heat1D` |  | arkode/C_serial | ran |  | 867 | same |  | [`ark_heat1D.out`](outputs/ark_heat1D.out) |
| `ark_kepler` | `--stepper ERK --step-mode adapt` | arkode/C_serial | ran |  | 5243 | same |  | [`ark_kepler_--stepper_ERK_--step-mode_adapt.out`](outputs/ark_kepler_--stepper_ERK_--step-mode_adapt.out) |
| `ark_kepler` | `--stepper ERK --step-mode fixed --count-orbits` | arkode/C_serial | ran |  | 10534 | ws-only | 36 | [`ark_kepler_--stepper_ERK_--step-mode_fixed_--count-orbits.out`](outputs/ark_kepler_--stepper_ERK_--step-mode_fixed_--count-orbits.out) |
| `ark_kepler` | `--stepper SPRK --step-mode fixed --count-orbits --use-compensated-sums` | arkode/C_serial | ran |  | 10258 | ws-only | 28 | [`ark_kepler_--stepper_SPRK_--step-mode_fixed_--count-orbits_--use-compensated-sums.out`](outputs/ark_kepler_--stepper_SPRK_--step-mode_fixed_--count-orbits_--use-compensated-sums.out) |
| `ark_kepler` | `--stepper SPRK --step-mode fixed --method ARKODE_SPRK_EULER_1_1 --tf 50 --check-order --nout 1` | arkode/C_serial | ran |  | 8313 | ws-only | 242 | [`ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_EULER_1_1_--tf_50_--check-order_--nout_1.out`](outputs/ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_EULER_1_1_--tf_50_--check-order_--nout_1.out) |
| `ark_kepler` | `--stepper SPRK --step-mode fixed --method ARKODE_SPRK_LEAPFROG_2_2 --tf 50 --check-order --nout 1` | arkode/C_serial | ran |  | 8312 | same |  | [`ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_LEAPFROG_2_2_--tf_50_--check-order_--nout_1.out`](outputs/ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_LEAPFROG_2_2_--tf_50_--check-order_--nout_1.out) |
| `ark_kepler` | `--stepper SPRK --step-mode fixed --method ARKODE_SPRK_MCLACHLAN_2_2 --tf 50 --check-order --nout 1` | arkode/C_serial | ran |  | 8312 | same |  | [`ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_MCLACHLAN_2_2_--tf_50_--check-order_--nout_1.out`](outputs/ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_MCLACHLAN_2_2_--tf_50_--check-order_--nout_1.out) |
| `ark_kepler` | `--stepper SPRK --step-mode fixed --method ARKODE_SPRK_MCLACHLAN_3_3 --tf 50 --check-order --nout 1` | arkode/C_serial | ran |  | 8196 | same |  | [`ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_MCLACHLAN_3_3_--tf_50_--check-order_--nout_1.out`](outputs/ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_MCLACHLAN_3_3_--tf_50_--check-order_--nout_1.out) |
| `ark_kepler` | `--stepper SPRK --step-mode fixed --method ARKODE_SPRK_MCLACHLAN_4_4 --tf 50 --check-order --nout 1` | arkode/C_serial | ran |  | 8205 | same |  | [`ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_MCLACHLAN_4_4_--tf_50_--check-order_--nout_1.out`](outputs/ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_MCLACHLAN_4_4_--tf_50_--check-order_--nout_1.out) |
| `ark_kepler` | `--stepper SPRK --step-mode fixed --method ARKODE_SPRK_MCLACHLAN_5_6 --tf 50 --check-order --nout 1` | arkode/C_serial | ran |  | 8198 | same |  | [`ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_MCLACHLAN_5_6_--tf_50_--check-order_--nout_1.out`](outputs/ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_MCLACHLAN_5_6_--tf_50_--check-order_--nout_1.out) |
| `ark_kepler` | `--stepper SPRK --step-mode fixed --method ARKODE_SPRK_PSEUDO_LEAPFROG_2_2 --tf 50 --check-order --nout 1` | arkode/C_serial | ran |  | 8309 | same |  | [`ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_PSEUDO_LEAPFROG_2_2_--tf_50_--check-order_--nout_1.out`](outputs/ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_PSEUDO_LEAPFROG_2_2_--tf_50_--check-order_--nout_1.out) |
| `ark_kepler` | `--stepper SPRK --step-mode fixed --method ARKODE_SPRK_RUTH_3_3 --tf 50 --check-order --nout 1` | arkode/C_serial | ran |  | 8200 | ws-only | 242 | [`ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_RUTH_3_3_--tf_50_--check-order_--nout_1.out`](outputs/ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_RUTH_3_3_--tf_50_--check-order_--nout_1.out) |
| `ark_kepler` | `--stepper SPRK --step-mode fixed --method ARKODE_SPRK_YOSHIDA_6_8 --tf 50 --check-order --nout 1` | arkode/C_serial | ran |  | 8203 | same |  | [`ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_YOSHIDA_6_8_--tf_50_--check-order_--nout_1.out`](outputs/ark_kepler_--stepper_SPRK_--step-mode_fixed_--method_ARKODE_SPRK_YOSHIDA_6_8_--tf_50_--check-order_--nout_1.out) |
| `ark_kepler` |  | arkode/C_serial | ran |  | 5036 | ws-only | 26 | [`ark_kepler.out`](outputs/ark_kepler.out) |
| `ark_kpr_mri` | `0 1 0.005` | arkode/C_serial | ran |  | 3586 | same |  | [`ark_kpr_mri_0_1_0.005.out`](outputs/ark_kpr_mri_0_1_0.005.out) |
| `ark_kpr_mri` | `1 0 0.01` | arkode/C_serial | ran |  | 3459 | same |  | [`ark_kpr_mri_1_0_0.01.out`](outputs/ark_kpr_mri_1_0_0.01.out) |
| `ark_kpr_mri` | `1 1 0.002` | arkode/C_serial | ran |  | 3596 | same |  | [`ark_kpr_mri_1_1_0.002.out`](outputs/ark_kpr_mri_1_1_0.002.out) |
| `ark_kpr_mri` | `2 4 0.002` | arkode/C_serial | ran |  | 3474 | same |  | [`ark_kpr_mri_2_4_0.002.out`](outputs/ark_kpr_mri_2_4_0.002.out) |
| `ark_kpr_mri` | `3 2 0.001` | arkode/C_serial | ran |  | 3481 | same |  | [`ark_kpr_mri_3_2_0.001.out`](outputs/ark_kpr_mri_3_2_0.001.out) |
| `ark_kpr_mri` | `4 3 0.001` | arkode/C_serial | ran |  | 3466 | same |  | [`ark_kpr_mri_4_3_0.001.out`](outputs/ark_kpr_mri_4_3_0.001.out) |
| `ark_kpr_mri` | `5 4 0.001` | arkode/C_serial | ran |  | 3466 | same |  | [`ark_kpr_mri_5_4_0.001.out`](outputs/ark_kpr_mri_5_4_0.001.out) |
| `ark_kpr_mri` | `6 5 0.001` | arkode/C_serial | ran |  | 3486 | same |  | [`ark_kpr_mri_6_5_0.001.out`](outputs/ark_kpr_mri_6_5_0.001.out) |
| `ark_kpr_mri` | `7 2 0.002` | arkode/C_serial | ran |  | 3619 | same |  | [`ark_kpr_mri_7_2_0.002.out`](outputs/ark_kpr_mri_7_2_0.002.out) |
| `ark_kpr_mri` | `8 3 0.001 -100 100 0.5 1` | arkode/C_serial | ran |  | 3609 | same |  | [`ark_kpr_mri_8_3_0.001_-100_100_0.5_1.out`](outputs/ark_kpr_mri_8_3_0.001_-100_100_0.5_1.out) |
| `ark_kpr_mri` | `9 3 0.001 -100 100 0.5 1` | arkode/C_serial | ran |  | 3620 | same |  | [`ark_kpr_mri_9_3_0.001_-100_100_0.5_1.out`](outputs/ark_kpr_mri_9_3_0.001_-100_100_0.5_1.out) |
| `ark_kpr_mri` | `10 4 0.001 -100 100 0.5 1` | arkode/C_serial | ran |  | 3619 | same |  | [`ark_kpr_mri_10_4_0.001_-100_100_0.5_1.out`](outputs/ark_kpr_mri_10_4_0.001_-100_100_0.5_1.out) |
| `ark_kpr_mri` | `11 2 0.001` | arkode/C_serial | ran |  | 3634 | same |  | [`ark_kpr_mri_11_2_0.001.out`](outputs/ark_kpr_mri_11_2_0.001.out) |
| `ark_kpr_mri` | `12 3 0.005` | arkode/C_serial | ran |  | 3615 | same |  | [`ark_kpr_mri_12_3_0.005.out`](outputs/ark_kpr_mri_12_3_0.005.out) |
| `ark_kpr_mri` | `13 4 0.01` | arkode/C_serial | ran |  | 3612 | same |  | [`ark_kpr_mri_13_4_0.01.out`](outputs/ark_kpr_mri_13_4_0.01.out) |
| `ark_KrylovDemo_prec` |  | arkode/C_serial | ran |  | 26804 | same |  | [`ark_KrylovDemo_prec.out`](outputs/ark_KrylovDemo_prec.out) |
| `ark_KrylovDemo_prec` | `1` | arkode/C_serial | ran |  | 26804 | same |  | [`ark_KrylovDemo_prec_1.out`](outputs/ark_KrylovDemo_prec_1.out) |
| `ark_KrylovDemo_prec` | `2` | arkode/C_serial | ran |  | 26804 | same |  | [`ark_KrylovDemo_prec_2.out`](outputs/ark_KrylovDemo_prec_2.out) |
| `ark_lotka_volterra_ASA` | `--check-freq 1` | arkode/C_serial | ran |  | 1203 | same |  | [`ark_lotka_volterra_ASA_--check-freq_1.out`](outputs/ark_lotka_volterra_ASA_--check-freq_1.out) |
| `ark_lotka_volterra_ASA` | `--check-freq 5` | arkode/C_serial | ran |  | 1206 | same |  | [`ark_lotka_volterra_ASA_--check-freq_5.out`](outputs/ark_lotka_volterra_ASA_--check-freq_5.out) |
| `ark_onewaycouple_mri` |  | arkode/C_serial | ran |  | 1077 | same |  | [`ark_onewaycouple_mri.out`](outputs/ark_onewaycouple_mri.out) |
| `ark_reaction_diffusion_mri` |  | arkode/C_serial | ran |  | 2276 | ws-only | 70 | [`ark_reaction_diffusion_mri.out`](outputs/ark_reaction_diffusion_mri.out) |
| `ark_robertson_constraints` |  | arkode/C_serial | ran |  | 6297 | same |  | [`ark_robertson_constraints.out`](outputs/ark_robertson_constraints.out) |
| `ark_robertson_root` |  | arkode/C_serial | ran |  | 1558 | same |  | [`ark_robertson_root.out`](outputs/ark_robertson_root.out) |
| `ark_robertson` |  | arkode/C_serial | ran |  | 6855 | same |  | [`ark_robertson.out`](outputs/ark_robertson.out) |
| `ark_twowaycouple_mri` |  | arkode/C_serial | ran |  | 1415 | same |  | [`ark_twowaycouple_mri.out`](outputs/ark_twowaycouple_mri.out) |
| `ark_brusselator_fp` | `1` | arkode/C_serial | ran |  | 1107 | same |  | [`ark_brusselator_fp_1.out`](outputs/ark_brusselator_fp_1.out) |
