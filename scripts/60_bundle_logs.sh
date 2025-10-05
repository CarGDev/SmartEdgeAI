#!/bin/bash
set -eu
. "$(dirname "$0")/env.sh"

TE="$LOG_DATA/TERMINAL_EXCERPTS.txt"
SE="$LOG_DATA/STATS_EXCERPTS.txt"
: > "$TE"; : > "$SE"

for f in "$LOG_DATA"/*.stdout.log; do
  [ -f "$f" ] || continue
  echo "===== $(basename "$f") =====" >> "$TE"
  (head -n 20 "$f"; echo "..."; tail -n 20 "$f") >> "$TE"
  echo >> "$TE"
done

for d in "$OUT_DATA"/*; do
  [ -d "$d" ] || continue
  S="$d/stats.txt"
  [ -f "$S" ] || continue
  echo "===== $(basename "$d") =====" >> "$SE"
  awk '/^sim_seconds|^system\.cpu\.ipc|^system\.cpu0\.ipc|^system\.cpu\.numCycles|^system\.cpu0\.numCycles|^system\.cpu\.commit\.committedInsts|^system\.cpu0\.commit\.committedInsts|^system\.l2\.overall_miss_rate::total/' "$S" >> "$SE"
  echo >> "$SE"
done

# mirror to repo
cp "$TE" "$LOG_IOT/TERMINAL_EXCERPTS.txt"
cp "$SE" "$LOG_IOT/STATS_EXCERPTS.txt"
echo "[bundle] wrote $TE and $SE (mirrored into iot/logs)"

