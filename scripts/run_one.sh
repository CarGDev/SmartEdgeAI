#!/bin/bash
set -eu
. "$(dirname "$0")/env.sh"

if [ $# -lt 5 ]; then
  echo "Usage: $0 <workload:{tinyml_kws|sensor_fusion|aes_ccm|attention_kernel}> <core:{big|little|hybrid}> <dvfs:{high|low}> <drowsy:{0|1}> <l2:{512kB|1MB}> [mem=16GB]"
  exit 1
fi

W=$1; CORE=$2; DV=$3; DROWSY=$4; L2=$5; MEM=${6:-16GB}
TAG="${W}_${CORE}_${DV}_l2${L2}_d${DROWSY}"
OUTDIR="$OUT_DATA/$TAG"

mkdir -p "$OUTDIR"
echo "[run_one] $TAG mem=$MEM -> $OUTDIR"

# For IoT LLM simulation with x86-ubuntu-run.py
# Map core types to CPU types (simplified for IoT)
if [ "$CORE" = "big" ]; then
  CPU_TYPE="O3CPU"
elif [ "$CORE" = "little" ]; then
  CPU_TYPE="TimingSimpleCPU"
else
  CPU_TYPE="O3CPU"  # Default for hybrid
fi

"$GEM5_BIN" "$CFG" \
  --command="$RUN/$W" \
  --mem-size="$MEM" \
  --cpu-type="$CPU_TYPE" \
  > "$LOG_DATA/${TAG}.stdout.log" \
  2> "$LOG_DATA/${TAG}.stderr.log"

# Copy stats from m5out to our output directory
if [ -f "m5out/stats.txt" ]; then
  cp m5out/stats.txt "$OUTDIR/"
  echo "[run_one] Copied stats.txt from m5out to $OUTDIR"
fi

# mirror to repo
rsync -a --delete "$OUTDIR/" "$OUT_IOT/$TAG/"
rsync -a "$LOG_DATA/${TAG}."* "$LOG_IOT/" 2>/dev/null || true

echo "[run_one] DONE"

