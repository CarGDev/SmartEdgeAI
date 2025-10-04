#!/bin/bash
set -eu
source "$(dirname "$0")/00_env.sh"

if [[ $# -lt 5 ]]; then
  echo "Usage: $0 <workload:{tinyml_kws|sensor_fusion|aes_ccm|attention_kernel}> <core:{big|little|hybrid}> <dvfs:{high|low}> <drowsy:{0|1}> <l2:{512kB|1MB}> [mem=16GB]"
  exit 1
fi

W=$1; CORE=$2; DV=$3; DROWSY=$4; L2=$5; MEM=${6:-16GB}
OUT="$OUTROOT/${W}_${CORE}_${DV}_l2${L2}_d${DROWSY}"

mkdir -p "$OUT"
echo "[run_one] $W $CORE $DV L2=$L2 drowsy=$DROWSY mem=$MEM -> $OUT"

"$GEM5" "$CFG" \
  --cmd="$RUN/$W" \
  --mem="$MEM" \
  --dvfs="$DV" \
  --drowsy="$DROWSY" \
  --l2="$L2" \
  --outdir="$OUT" \
  > "$LOGROOT/${W}_${CORE}_${DV}_l2${L2}_d${DROWSY}.stdout.log" \
  2> "$LOGROOT/${W}_${CORE}_${DV}_l2${L2}_d${DROWSY}.stderr.log"

echo "[run_one] DONE"

