# SmartEdgeAI - (gem5)

This repo holds **all scripts, commands, and logs** for Phase 3.

## Prerequisites

### Install gem5
Before running any simulations, you need to install and build gem5:

```bash
# Clone gem5 repository
git clone https://github.com/gem5/gem5.git /home/carlos/projects/gem5/gem5src/gem5

# Build gem5 for ARM
cd /home/carlos/projects/gem5/gem5src/gem5
scons build/ARM/gem5.opt -j$(nproc)

# Verify installation
sh scripts/check_gem5.sh
```

### Install ARM Cross-Compiler
```bash
# Ubuntu/Debian
sudo apt-get install gcc-arm-linux-gnueabihf

# macOS (if using Homebrew)
brew install gcc-arm-linux-gnueabihf
```

## Quick Start (Run Everything)

To run the complete workflow automatically:

```bash
chmod +x run_all.sh
sh run_all.sh
```

This will execute all steps in sequence with error checking and progress reporting.

## Manual Steps (Order of operations)

### 0. Check Prerequisites
```bash
sh scripts/check_gem5.sh
```
**Check logs**: Should show "✓ All checks passed!" or installation instructions

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
- gem5 binary: `/home/carlos/projects/gem5/gem5src/gem5/build/ARM/gem5.opt` (updated from tree.log analysis)
- config:      `scripts/hetero_big_little.py`
- workloads:   `/home/carlos/projects/gem5/gem5-run/{tinyml_kws,sensor_fusion,aes_ccm,attention_kernel}`

## Output Locations
- **Results**: `/home/carlos/projects/gem5/gem5-data/SmartEdgeAI/results/` (mirrored to `results/`)
- **Logs**: `/home/carlos/projects/gem5/gem5-data/SmartEdgeAI/logs/` (mirrored to `logs/`)

## Troubleshooting

### Common Issues

**Empty stats.txt files (0 bytes)**
- **Cause**: gem5 binary doesn't exist or simulation failed
- **Solution**: Run `sh scripts/check_gem5.sh` and install gem5 if needed
- **Check**: `ls -la /home/carlos/projects/gem5/gem5src/gem5/build/ARM/gem5.opt`

**CSV extraction shows empty values**
- **Cause**: Simulation didn't run, so no statistics were generated
- **Solution**: Fix gem5 installation first, then re-run simulations

**"ModuleNotFoundError: No module named 'matplotlib'"**
- **Solution**: Install matplotlib: `pip install matplotlib` or `sudo apt-get install python3-matplotlib`

**"ValueError: could not convert string to float: ''"**
- **Cause**: Empty CSV values from failed simulations
- **Solution**: Fixed in updated scripts - they now handle empty values gracefully

**Permission errors**
- **Solution**: Make scripts executable: `chmod +x scripts/*.sh`

**Path issues**
- **Solution**: Verify `ROOT` variable in `scripts/env.sh` points to correct gem5 installation

### Debugging Steps
1. **Check gem5 installation**: `sh scripts/check_gem5.sh`
2. **Verify workload binaries**: `ls -la /home/carlos/projects/gem5/gem5-run/`
3. **Test single simulation**: `sh scripts/run_one.sh tinyml_kws big high 0 1MB`
4. **Check simulation logs**: `cat logs/tinyml_kws_big_high_l21MB_d0.stdout.log`
5. **Verify stats output**: `ls -l /home/carlos/projects/gem5/gem5-data/SmartEdgeAI/results/tinyml_kws_big_high_l21MB_d0/stats.txt`

