#!/bin/bash
set -eu
. "$(dirname "$0")/env.sh"

echo "[build_workloads] Compiling all workloads..."

# Compile tinyml_kws
echo "[build_workloads] Compiling tinyml_kws..."
gcc -O2 -static -o "$RUN/tinyml_kws" \
  "$(dirname "$0")/../workloads/tinyml_kws.c" -lm

# Compile sensor_fusion
echo "[build_workloads] Compiling sensor_fusion..."
gcc -O2 -static -o "$RUN/sensor_fusion" \
  "$(dirname "$0")/../workloads/sensor_fusion.c" -lm

# Compile aes_ccm
echo "[build_workloads] Compiling aes_ccm..."
gcc -O2 -static -o "$RUN/aes_ccm" \
  "$(dirname "$0")/../workloads/aes_ccm.c"

# Compile attention_kernel
echo "[build_workloads] Compiling attention_kernel..."
gcc -O2 -static -o "$RUN/attention_kernel" \
  "$(dirname "$0")/../workloads/attention_kernel.c" -lm

# Compile IoT LLM simulation
echo "[build_workloads] Compiling iot_llm_sim..."
gcc -O2 -static -o "$RUN/iot_llm_sim" \
  "$(dirname "$0")/../iot_llm_sim.c"

echo "[build_workloads] All workloads compiled successfully!"
echo "[build_workloads] Binaries created in $RUN/"
ls -la "$RUN/"
