#!/usr/bin/env bash
# Regenera la paleta (matugen) a partir del wallpaper actual.
# Fuente: estado de Quickshell -> proceso swaybg -> default.
set -u

STATE="$HOME/.config/quickshell/wallpaper.json"
wall=""

wall=$(python3 - "$STATE" <<'PY' 2>/dev/null
import json, os, subprocess, sys

try:
    state = json.load(open(sys.argv[1]))
except Exception:
    state = {}

focused = ""
try:
    out = subprocess.run(["hyprctl", "-j", "monitors"],
                         capture_output=True, text=True).stdout
    for mon in json.loads(out):
        if mon.get("focused") and not mon.get("disabled"):
            focused = mon.get("name", "")
            break
except Exception:
    pass

per = state.get("monitors") or {}
src = per.get(focused) or state.get("default") or ""
if src and os.path.isfile(src):
    print(src)
PY
)

# Fallback: proceso swaybg en marcha (sin comillas en /proc).
if [ -z "$wall" ]; then
    wall=$(ps -eo args= 2>/dev/null | sed -n 's/^swaybg .*-i \(.*\) -m .*/\1/p' | head -n 1 | sed 's/^"//; s/"$//')
fi

# Último recurso.
if [ -z "$wall" ] || [ ! -f "$wall" ]; then
    wall="$HOME/.config/hypr/wallpapers/default.jpg"
fi

matugen image "$wall" -t scheme-content -q

# La barra vigila theme.json; no hace falta reiniciarla.
exit 0
