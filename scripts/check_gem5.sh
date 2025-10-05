#!/bin/bash
set -eu
. "$(dirname "$0")/env.sh"

echo "[check_gem5] Checking gem5 installation..."

# Check if gem5 binary exists
if [ ! -x "$GEM5_BIN" ]; then
    echo "[check_gem5] ERROR: gem5 binary not found at $GEM5_BIN"
    echo "[check_gem5] You need to install and build gem5 first."
    echo ""
    echo "To install gem5:"
    echo "1. Clone gem5 repository:"
    echo "   git clone https://github.com/gem5/gem5.git $ROOT/gem5src/gem5"
    echo ""
    echo "2. Build gem5 for ARM:"
    echo "   cd $ROOT/gem5src/gem5"
    echo "   scons build/ARM/gem5.opt -j\$(nproc)"
    echo ""
    echo "3. Verify the binary exists:"
    echo "   ls -la $GEM5_BIN"
    echo ""
    echo "Alternative: Install gem5 via package manager:"
    echo "   sudo apt-get install gem5  # Ubuntu/Debian"
    echo "   brew install gem5          # macOS"
    exit 1
fi

echo "[check_gem5] ✓ gem5 binary found at $GEM5_BIN"

# Check if gem5 runs
if ! "$GEM5_BIN" --help >/dev/null 2>&1; then
    echo "[check_gem5] ERROR: gem5 binary exists but cannot run"
    echo "[check_gem5] Try running: $GEM5_BIN --help"
    exit 1
fi

echo "[check_gem5] ✓ gem5 binary is executable"

# Check if ARM cross-compiler exists
if ! command -v arm-linux-gnueabihf-gcc >/dev/null 2>&1; then
    echo "[check_gem5] WARNING: ARM cross-compiler not found"
    echo "[check_gem5] Install with: sudo apt-get install gcc-arm-linux-gnueabihf"
    echo "[check_gem5] This is needed to compile workloads for ARM simulation"
fi

echo "[check_gem5] ✓ All checks passed!"
