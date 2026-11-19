#!/usr/bin/env bash
# Devuelve el color de acento (#rrggbb) basado en el tono predominante
# del wallpaper del monitor enfocado (estado de Quickshell).
set -u

STATE="$HOME/.config/quickshell/wallpaper.json"
DEFAULT="$HOME/.config/hypr/wallpapers/default.jpg"

SRC=$(python3 - "$STATE" "$DEFAULT" <<'PY'
import json, os, subprocess, sys

state_path, default = sys.argv[1], sys.argv[2]

try:
    state = json.load(open(state_path))
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
if not src or not os.path.isfile(src):
    src = default
print(src)
PY
)

[ -f "$SRC" ] || exit 1

magick "$SRC" -resize 160x160^ -gravity center -extent 160x160 -depth 8 rgb:- \
| python3 -c '
import sys, colorsys, collections

data = sys.stdin.buffer.read()
buckets = collections.defaultdict(lambda: [0, 0, 0, 0])

for i in range(0, len(data) - 2, 3):
    r, g, b = data[i], data[i + 1], data[i + 2]
    h, l, s = colorsys.rgb_to_hls(r / 255.0, g / 255.0, b / 255.0)
    if s < 0.22 or l < 0.08 or l > 0.94:
        continue
    key = (int(h * 36), int(s * 6))
    e = buckets[key]
    e[0] += r
    e[1] += g
    e[2] += b
    e[3] += 1

if not buckets:
    # Respaldo: promedio de toda la imagen.
    buckets[(0, 0)] = [sum(data[0::3]), sum(data[1::3]), sum(data[2::3]),
                       max(1, len(data) // 3)]

e = max(buckets.values(), key=lambda v: v[3])
r, g, b = e[0] / e[3], e[1] / e[3], e[2] / e[3]
h, l, s = colorsys.rgb_to_hls(r / 255.0, g / 255.0, b / 255.0)

# Acento pastel legible sobre fondo oscuro, como el resto de la paleta.
s = max(0.45, min(0.72, s))
l = 0.84
r, g, b = colorsys.hls_to_rgb(h, l, s)

print("#%02x%02x%02x" % (round(r * 255), round(g * 255), round(b * 255)))
'
