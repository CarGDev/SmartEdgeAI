# SmartEdgeAI - (gem5)

This repo holds **all scripts, commands, and logs** for Phase 3.

## Order of operations
1) `scripts/00_env.sh` – sets env vars used by all scripts  
2) `scripts/10_run_one.sh` – run a single experiment with clear args  
3) `scripts/20_sweep.sh` – run the full matrix  
4) `scripts/30_extract_csv.sh` – collect gem5 stats → CSV  
5) `scripts/40_energy_post.py` – compute Energy/Power/**EDP=J×s**  
6) `scripts/50_plot_epi.py` / `scripts/51_plot_edp_tinyml.py` – figures  
7) `scripts/60_bundle_logs.sh` – bundle terminal + stats excerpts  
8) (optional) `scripts/70_diff_table.py` – drowsy vs non-drowsy deltas

## Paths assumed
- gem5 binary: `../../build/ARM/gem5.opt`
- config:      `../../scripts/hetero_big_little.py`
- workloads:   `../../gem5-run/{tinyml_kws,sensor_fusion,aes_ccm,attention_kernel}`

All output is under `iot/results` and `iot/logs`.

