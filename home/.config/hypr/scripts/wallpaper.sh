#!/usr/bin/env bash
# Aplica el wallpaper guardado en ~/.config/quickshell/wallpaper.json.
# Uso: wallpaper.sh [all|<monitor>]
# Un proceso swaybg por monitor.
set -u

STATE="$HOME/.config/quickshell/wallpaper.json"
DEFAULT="$HOME/.config/hypr/wallpapers/default.jpg"
TARGET="${1:-all}"
[ "$TARGET" = "restore" ] && TARGET="all"

mapfile -t entries < <(python3 - "$STATE" "$DEFAULT" "$TARGET" <<'PY'
import json, os, subprocess, sys

state_path, default, target = sys.argv[1], sys.argv[2], sys.argv[3]

try:
    state = json.load(open(state_path))
except Exception:
    state = {}

monitors = []
try:
    out = subprocess.run(["hyprctl", "-j", "monitors"],
                         capture_output=True, text=True).stdout
    monitors = [m["name"] for m in json.loads(out) if not m.get("disabled")]
except Exception:
    pass

if not monitors:
    monitors = ["eDP-1"]

if target != "all":
    monitors = [m for m in monitors if m == target] or [target]

per = state.get("monitors") or {}
fallback = state.get("default") or default
if not os.path.isfile(fallback):
    fallback = default

for mon in monitors:
    path = per.get(mon) or fallback
    if not path or not os.path.isfile(path):
        path = fallback
    print(f"{mon}\t{path}")
PY
)

if [ "$TARGET" = "all" ]; then
    pkill -x swaybg 2>/dev/null
else
    pkill -f "swaybg -o $TARGET " 2>/dev/null
fi
sleep 0.2

for entry in "${entries[@]}"; do
    [ -n "$entry" ] || continue
    mon="${entry%%$'\t'*}"
    path="${entry#*$'\t'}"
    swaybg -o "$mon" -i "$path" -m fill >/dev/null 2>&1 &
done

exit 0
