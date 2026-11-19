#!/usr/bin/env bash
# Mantiene dos watchers de wl-paste (texto e imagen) alimentando cliphist.
set -u

if [ "$(pgrep -cx wl-paste)" -lt 2 ]; then
    pkill -x wl-paste 2>/dev/null
    wl-paste --type text  --watch cliphist store >/dev/null 2>&1 &
    wl-paste --type image --watch cliphist store >/dev/null 2>&1 &
fi
