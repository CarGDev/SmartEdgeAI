#!/bin/bash
set -eu

ROOT="/home/carlos/projects/gem5"
SRC="$ROOT/gem5src/gem5"
IOT="$ROOT/iot"
DATA="$ROOT/gem5-data"                   # persistent (symlink to /mnt/storage/…)
RUN="$ROOT/gem5-run"                     # workloads
CFG="/home/carlos/projects/gem5/gem5src/gem5/configs/example/arm/starter_se.py"

# --- build target (ARM by default) ---
# Updated path based on tree.log analysis: ../gem5src/gem5/build/ARM/gem5.opt
GEM5_BIN="$ROOT/gem5src/gem5/build/ARM/gem5.opt"

# --- auto-build if missing (non-interactive: sends newline to accept hooks prompt) ---
if [ ! -x "$GEM5_BIN" ]; then
  echo "[env] gem5.opt not found, building at $GEM5_BIN via $SRC ..."
  ( cd "$SRC" && printf '\n' | scons "$GEM5_BIN" -j"$(nproc)" )
fi

# verify binary
[ -x "$GEM5_BIN" ] || { echo "[env] build failed: $GEM5_BIN missing"; exit 2; }

# --- primary outputs (data) + mirrors (repo) ---
OUT_DATA="$DATA/SmartEdgeAI/results"
LOG_DATA="$DATA/SmartEdgeAI/logs"
OUT_IOT="$IOT/results"
LOG_IOT="$IOT/logs"
mkdir -p "$OUT_DATA" "$LOG_DATA" "$OUT_IOT" "$LOG_IOT"

# export for child scripts
export ROOT SRC IOT DATA RUN CFG GEM5_BIN OUT_DATA LOG_DATA OUT_IOT LOG_IOT

# minimal env log
{
  echo "==== env ===="
  echo "ROOT=$ROOT"
  echo "SRC=$SRC"
  echo "GEM5_BIN=$GEM5_BIN"
  echo "CFG=$CFG"
  echo "RUN=$RUN"
  echo "OUT_DATA=$OUT_DATA"
  echo "LOG_DATA=$LOG_DATA"
  date
} >> "$LOG_IOT/env.txt"

echo "[env] READY"
