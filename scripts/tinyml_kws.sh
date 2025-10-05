#!/bin/bash
set -eu
. "$(dirname "$0")/env.sh"

# Compile the actual tinyml_kws workload
echo "[tinyml_kws] Compiling workload..."
arm-linux-gnueabihf-gcc -O2 -static -o "$RUN/tinyml_kws" \
  "$(dirname "$0")/../workloads/tinyml_kws.c" -lm

echo "[tinyml_kws] Binary created at $RUN/tinyml_kws"

