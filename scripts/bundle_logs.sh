#!/bin/bash
set -eu
. "$(dirname "$0")/env.sh"

TE="$LOG_DATA/TERMINAL_EXCERPTS.txt"
SE="$LOG_DATA/STATS_EXCERPTS.txt"
: > "$TE"; : > "$SE"

log_count=0
for f in "$LOG_DATA"/*.stdout.log; do
  [ -f "$f" ] || continue
  log_count=$((log_count + 1))
  echo "===== $(basename "$f") =====" >> "$TE"
  (head -n 20 "$f"; echo "..."; tail -n 20 "$f") >> "$TE"
  echo >> "$TE"
done

if [ $log_count -eq 0 ]; then
  echo "[bundle] WARNING: No stdout.log files found in $LOG_DATA"
fi

stats_count=0
for d in "$OUT_DATA"/*; do
  [ -d "$d" ] || continue
  S="$d/stats.txt"
  [ -f "$S" ] || continue
  stats_count=$((stats_count + 1))
  echo "===== $(basename "$d") =====" >> "$SE"
  awk '/^sim_seconds|^system\.cpu\.ipc|^system\.cpu0\.ipc|^system\.cpu\.numCycles|^system\.cpu0\.numCycles|^system\.cpu\.commit\.committedInsts|^system\.cpu0\.commit\.committedInsts|^system\.l2\.overall_miss_rate::total/' "$S" >> "$SE"
  echo >> "$SE"
done

if [ $stats_count -eq 0 ]; then
  echo "[bundle] WARNING: No stats.txt files found in $OUT_DATA"
fi

# mirror to repo
cp "$TE" "$LOG_IOT/TERMINAL_EXCERPTS.txt"
cp "$SE" "$LOG_IOT/STATS_EXCERPTS.txt"
echo "[bundle] wrote $TE and $SE (mirrored into iot/logs)"

