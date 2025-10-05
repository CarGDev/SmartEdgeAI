#!/bin/bash
set -eu
. "$(dirname "$0")/env.sh"

CSV_DATA="$OUT_DATA/summary.csv"
CSV_IOT="$OUT_IOT/summary.csv"
echo "workload,core,dvfs,l2,drowsy,sim_seconds,ipc,cycles,insts,l2_miss_rate" > "$CSV_DATA"

for d in "$OUT_DATA"/*; do
  [ -d "$d" ] || continue
  base=$(basename "$d")
  W=$(echo "$base" | cut -d'_' -f1)
  CORE=$(echo "$base" | cut -d'_' -f2)
  DVFS=$(echo "$base" | cut -d'_' -f3)
  L2=$(echo "$base"  | sed -E 's/.*_l2([^_]+).*/\1/')
  DROW=$(echo "$base" | sed -E 's/.*_d([01]).*/\1/')
  S="$d/stats.txt"

  SIMS=$(awk '/^sim_seconds/ {print $2}' "$S")
  IPC=$(awk '/^system\.cpu\.ipc|^system\.cpu0\.ipc/ {print $2}' "$S" | head -n1)
  CYC=$(awk '/^system\.cpu\.numCycles|^system\.cpu0\.numCycles/ {print $2}' "$S" | head -n1)
  INST=$(awk '/^system\.cpu\.commit\.committedInsts|^system\.cpu0\.commit\.committedInsts/ {print $2}' "$S" | head -n1)
  L2MR=$(awk '/^system\.l2\.overall_miss_rate::total/ {print $2}' "$S")

  echo "$W,$CORE,$DVFS,$L2,$DROW,$SIMS,$IPC,$CYC,$INST,$L2MR" >> "$CSV_DATA"
done

cp "$CSV_DATA" "$CSV_IOT"
echo "[extract] wrote $CSV_DATA and mirrored to $CSV_IOT"

