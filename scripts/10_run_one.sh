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

"$GEM5" "$CFG" \
  --cmd="$RUN/$W" \
  --mem="$MEM" \
  --dvfs="$DV" \
  --drowsy="$DROWSY" \
  --l2="$L2" \
  --outdir="$OUTDIR" \
  > "$LOG_DATA/${TAG}.stdout.log" \
  2> "$LOG_DATA/${TAG}.stderr.log"

# mirror to repo (iot/)
rsync -a --delete "$OUTDIR/" "$OUT_IOT/$TAG/"
rsync -a "$LOG_DATA/${TAG}."* "$LOG_IOT/" 2>/dev/null || true

echo "[run_one] DONE"

