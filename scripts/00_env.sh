#!/bin/bash
set -eu
# source this from anywhere inside /home/carlos/projects/gem5

ROOT="/home/carlos/projects/gem5"
export GEM5="$ROOT/build/ARM/gem5.opt"
export CFG="$ROOT/scripts/hetero_big_little.py"
export RUN="$ROOT/gem5-run"
export OUTROOT="$ROOT/iot/results"
export LOGROOT="$ROOT/iot/logs"

mkdir -p "$OUTROOT" "$LOGROOT"

# record environment (append-only)
{
  echo "==== uname ===="; uname -a
  echo; echo "==== date ===="; date
  echo; echo "==== gem5 git ===="; (git -C "$ROOT/gem5src" rev-parse --short HEAD 2>/dev/null || echo n/a)
} >> "$LOGROOT/env.txt"
echo "[env] READY"

