#!/bin/bash
set -eu
. "$(dirname "$0")/env.sh"

echo "[build_workloads] Compiling all workloads..."

# Compile tinyml_kws
echo "[build_workloads] Compiling tinyml_kws..."
arm-linux-gnueabihf-gcc -O2 -static -o "$RUN/tinyml_kws" \
  "$(dirname "$0")/../workloads/tinyml_kws.c" -lm

# Compile sensor_fusion
echo "[build_workloads] Compiling sensor_fusion..."
arm-linux-gnueabihf-gcc -O2 -static -o "$RUN/sensor_fusion" \
  "$(dirname "$0")/../workloads/sensor_fusion.c" -lm

# Compile aes_ccm
echo "[build_workloads] Compiling aes_ccm..."
arm-linux-gnueabihf-gcc -O2 -static -o "$RUN/aes_ccm" \
  "$(dirname "$0")/../workloads/aes_ccm.c"

# Compile attention_kernel
echo "[build_workloads] Compiling attention_kernel..."
arm-linux-gnueabihf-gcc -O2 -static -o "$RUN/attention_kernel" \
  "$(dirname "$0")/../workloads/attention_kernel.c" -lm

echo "[build_workloads] All workloads compiled successfully!"
echo "[build_workloads] Binaries created in $RUN/"
ls -la "$RUN/"
