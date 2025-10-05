#!/bin/bash
set -eu
. "$(dirname "$0")/00_env.sh"

run_case () {
  local W=$1 CORE=$2 DV=$3 D=$4 L2=$5 MEM=16GB
  bash "$(dirname "$0")/10_run_one.sh" "$W" "$CORE" "$DV" "$D" "$L2" "$MEM"
}

for W in tinyml_kws sensor_fusion aes_ccm attention_kernel; do
  for DV in high low; do
    for D in 0 1; do
      for L2 in 512kB 1MB; do
        run_case "$W" big    "$DV" "$D" "$L2"
        run_case "$W" little "$DV" "$D" "$L2"
        run_case "$W" hybrid "$DV" "$D" "$L2"
      done
    done
  done
done

echo "[sweep] ALL DONE"

