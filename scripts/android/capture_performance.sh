#!/usr/bin/env bash
# Run locally in a terminal. No recording or repeated agent calls required.
set -euo pipefail
PACKAGE=com.onenonlygit.speedbreakerone
SERIAL="${1:?Usage: capture_performance.sh IP:PORT [APK]}"
APK="${2:-}"
command -v adb >/dev/null || { echo 'Install Android platform-tools first.' >&2; exit 1; }
adb connect "$SERIAL"
adb -s "$SERIAL" get-state
if [[ -n "$APK" ]]; then adb -s "$SERIAL" install -r "$APK"; fi
OUT="${SB_CAPTURE_DIR:-$PWD/SpeedBreaker-0.1.8-$(date +%Y%m%d-%H%M%S)}"
mkdir -p "$OUT"
adb -s "$SERIAL" shell am force-stop "$PACKAGE"
adb -s "$SERIAL" logcat -c
adb -s "$SERIAL" logcat -v threadtime SpeedBreakerOne:V SDL:V AndroidRuntime:E libc:F DEBUG:F '*:S' > "$OUT/logcat.txt" 2>&1 &
LOGGER=$!
cleanup() { kill "$LOGGER" 2>/dev/null || true; wait "$LOGGER" 2>/dev/null || true; }
trap cleanup EXIT
adb -s "$SERIAL" shell am start -n "$PACKAGE/.SpeedBreakerActivity"
printf '\nUse 720p, Frame Rate 60 and your usual device/driver settings.\nWarm up for 60 seconds, then repeat the same Quick Race.\nFor the automatic A/B test: Settings > Advanced > GPU Scheduling > Compare.\nDrive for 4 minutes; check shadows, tunnels, mirrors and audio. Start a second race.\nType done here to collect logs (10-minute timeout). No screen recording is running.\n\n'
IFS= read -r -t 600 ANSWER || true
adb -s "$SERIAL" shell dumpsys meminfo "$PACKAGE" > "$OUT/memory.txt" || true
adb -s "$SERIAL" shell dumpsys activity exit-info "$PACKAGE" > "$OUT/exit-info.txt" || true
adb -s "$SERIAL" shell dumpsys battery > "$OUT/battery.txt" || true
adb -s "$SERIAL" exec-out run-as "$PACKAGE" tar -cf - files/data/speedbreaker/logs > "$OUT/session-logs.tar"
tar -tf "$OUT/session-logs.tar" > "$OUT/session-log-files.txt"
[[ -s "$OUT/session-log-files.txt" ]] || { echo 'No app logs were extracted.' >&2; exit 1; }
cleanup
trap - EXIT
tar -czf "$OUT.tar.gz" -C "$(dirname "$OUT")" "$(basename "$OUT")"
printf '\nCapture ready: %s.tar.gz\n' "$OUT"
