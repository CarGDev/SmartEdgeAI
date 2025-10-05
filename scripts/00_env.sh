#!/bin/bash
set -eu

ROOT="/home/carlos/projects/gem5"
IOT="$ROOT/iot"
DATA="$ROOT/gem5-data"                     # persistent store (your symlink)
RUN="$ROOT/gem5-run"                       # workloads
CFG="$ROOT/scripts/hetero_big_little.py"   # gem5 config script

# auto-detect gem5.opt (ARM or ARM64)
if [ -x "$ROOT/build/ARM/gem5.opt" ]; then
  GEM5="$ROOT/build/ARM/gem5.opt"
elif [ -x "$ROOT/gem5-build/ARM/gem5.opt" ]; then
  GEM5="$ROOT/gem5-build/ARM/gem5.opt"
elif [ -x "$ROOT/gem5-build/ARM64/gem5.opt" ]; then
  GEM5="$ROOT/gem5-build/ARM64/gem5.opt"
else
  echo "[env] gem5.opt not found. Build it with:"
  echo "      scons build/ARM/gem5.opt -j\$(nproc)"
  exit 2
fi

# primary outputs in gem5-data, mirrored into iot/
OUT_DATA="$DATA/SmartEdgeAI/results"
LOG_DATA="$DATA/SmartEdgeAI/logs"
OUT_IOT="$IOT/results"
LOG_IOT="$IOT/logs"

# ensure directories
mkdir -p "$OUT_DATA" "$LOG_DATA" "$OUT_IOT" "$LOG_IOT"

# export for child scripts
export ROOT IOT DATA RUN CFG GEM5 OUT_DATA LOG_DATA OUT_IOT LOG_IOT

# minimal env log
{
  echo "==== env ===="
  echo "ROOT=$ROOT"
  echo "GEM5=$GEM5"
  echo "CFG=$CFG"
  echo "RUN=$RUN"
  echo "OUT_DATA=$OUT_DATA"
  echo "LOG_DATA=$LOG_DATA"
  date
} >> "$LOG_IOT/env.txt"

echo "[env] READY"

