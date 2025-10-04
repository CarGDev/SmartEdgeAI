#!/bin/bash
set -eu
source "$(dirname "$0")/00_env.sh"

# terminal excerpts
: > "$LOGROOT/TERMINAL_EXCERPTS.txt"
for f in "$LOGROOT"/*.stdout.log; do
  echo "===== $(basename "$f") =====" >> "$LOGROOT/TERMINAL_EXCERPTS.txt"
  (head -n 20 "$f"; echo "..."; tail -n 20 "$f") >> "$LOGROOT/TERMINAL_EXCERPTS.txt"
  echo >> "$LOGROOT/TERMINAL_EXCERPTS.txt"
done
echo "[bundle] wrote $LOGROOT/TERMINAL_EXCERPTS.txt"

# stats excerpts
: > "$LOGROOT/STATS_EXCERPTS.txt"
for d in "$OUTROOT"/*; do
  [[ -d "$d" ]] || continue
  echo "===== $(basename "$d") =====" >> "$LOGROOT/STATS_EXCERPTS.txt"
  awk '/^sim_seconds|^system\.cpu\.ipc|^system\.cpu0\.ipc|^system\.cpu\.numCycles|^system\.cpu0\.numCycles|^system\.cpu\.commit\.committedInsts|^system\.cpu0\.commit\.committedInsts|^system\.l2\.overall_miss_rate::total/' "$d/stats.txt" >> "$LOGROOT/STATS_EXCERPTS.txt"
  echo >> "$LOGROOT/STATS_EXCERPTS.txt"
done
echo "[bundle] wrote $LOGROOT/STATS_EXCERPTS.txt"

