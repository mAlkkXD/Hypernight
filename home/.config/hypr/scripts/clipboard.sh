#!/usr/bin/env bash
# Historial de portapapeles con fuzzel
set -u

LANG_CODE=$("$HOME/.config/quickshell/scripts/ui-lang.sh")
if [ "$LANG_CODE" = "en" ]; then
    PROMPT=" clipboard "
else
    PROMPT=" portapapeles "
fi

sel=$(cliphist list | fuzzel --dmenu -p "$PROMPT" -w 60 -l 15) || exit 0
[ -z "$sel" ] && exit 0

printf '%s' "$sel" | cliphist decode | wl-copy
exit 0
