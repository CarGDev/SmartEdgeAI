#!/bin/bash
set -eu
cd /home/carlos/projects/gem5
scons build/ARM/gem5.opt -j"$(nproc)"
