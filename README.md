# SmartEdgeAI - (gem5)

This repo holds **all scripts, commands, and logs** for Phase 3.

## Order of operations

### 1. Setup Environment
```bash
sh scripts/env.sh
```
**Check logs**: `cat logs/env.txt` - Should show environment variables and "READY" message

### 2. Build Workloads
```bash
sh scripts/build_workloads.sh
```
**Check logs**: Look for "All workloads compiled successfully!" and verify binaries exist:
```bash
ls -la /home/carlos/projects/gem5/gem5-run/
```

### 3. Test Single Run
```bash
sh scripts/run_one.sh tinyml_kws big high 0 1MB
```
**Check logs**: 
- Verify stats.txt has content: `ls -l /home/carlos/projects/gem5/gem5-data/SmartEdgeAI/results/tinyml_kws_big_high_l21MB_d0/stats.txt`
- Check simulation output: `cat logs/tinyml_kws_big_high_l21MB_d0.stdout.log`
- Check for errors: `cat logs/tinyml_kws_big_high_l21MB_d0.stderr.log`

### 4. Run Full Matrix
```bash
sh scripts/sweep.sh
```
**Check logs**: Monitor progress and verify all combinations complete:
```bash
ls -la /home/carlos/projects/gem5/gem5-data/SmartEdgeAI/results/
```

### 5. Extract Statistics
```bash
sh scripts/extract_csv.sh
```
**Check logs**: Verify CSV was created with data:
```bash
head -5 /home/carlos/projects/gem5/gem5-data/SmartEdgeAI/results/summary.csv
```

### 6. Compute Energy Metrics
```bash
python3 scripts/energy_post.py
```
**Check logs**: Verify energy calculations:
```bash
head -5 /home/carlos/projects/gem5/gem5-data/SmartEdgeAI/results/summary_energy.csv
```

### 7. Generate Plots
```bash
python3 scripts/plot_epi.py
python3 scripts/plot_edp_tinyml.py
```
**Check logs**: Verify plots were created:
```bash
ls -la /home/carlos/projects/gem5/gem5-data/SmartEdgeAI/results/fig_*.png
```

### 8. Bundle Logs
```bash
sh scripts/bundle_logs.sh
```
**Check logs**: Verify bundled logs:
```bash
cat logs/TERMINAL_EXCERPTS.txt
cat logs/STATS_EXCERPTS.txt
```

### 9. (Optional) Generate Delta Analysis
```bash
python3 scripts/diff_table.py
```
**Check logs**: Verify delta calculations:
```bash
head -5 results/phase3_drowsy_deltas.csv
```

## Paths assumed
- gem5 binary: `/home/carlos/projects/gem5/build/ARM/gem5.opt`
- config:      `scripts/hetero_big_little.py`
- workloads:   `/home/carlos/projects/gem5/gem5-run/{tinyml_kws,sensor_fusion,aes_ccm,attention_kernel}`

## Output Locations
- **Results**: `/home/carlos/projects/gem5/gem5-data/SmartEdgeAI/results/` (mirrored to `results/`)
- **Logs**: `/home/carlos/projects/gem5/gem5-data/SmartEdgeAI/logs/` (mirrored to `logs/`)

## Troubleshooting
- **Empty stats.txt**: Check gem5 simulation logs for errors
- **Missing binaries**: Re-run `scripts/build_workloads.sh`
- **Permission errors**: Ensure scripts are executable: `chmod +x scripts/*.sh`
- **Path issues**: Verify `ROOT` variable in `scripts/env.sh` points to correct gem5 installation

