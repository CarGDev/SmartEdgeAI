#!/bin/bash
set -eu
ROOT=/home/carlos/projects/gem5
RUN=$ROOT/gem5-run
mkdir -p "$RUN"
arm-linux-gnueabihf-gcc -O2 -static -o "$RUN/tinyml_kws"        iot/scripts/tinyml_kws.c
arm-linux-gnueabihf-gcc -O2 -static -o "$RUN/attention_kernel"  iot/scripts/attention_kernel.c

