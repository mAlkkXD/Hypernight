#!/usr/bin/env bash
# Capturas: region | full | window
set -u

DIR="$HOME/Imágenes/Capturas"
mkdir -p "$DIR"
STAMP=$(date +%Y%m%d-%H%M%S)
OUT="$DIR/captura-$STAMP.png"

case "${1:-region}" in
    region)
        geom=$(slurp 2>/dev/null) || exit 1
        grim -g "$geom" "$OUT" || exit 1
        ;;
    full)
        grim "$OUT" || exit 1
        ;;
    window)
        hyprshot -m window -o "$DIR" -f "captura-$STAMP.png" >/dev/null 2>&1 || exit 1
        OUT="$DIR/captura-$STAMP.png"
        ;;
    *)
        exit 1
        ;;
esac

swappy -f "$OUT" -o "$OUT" >/dev/null 2>&1 &
wl-copy < "$OUT" 2>/dev/null || true
LANG_CODE=$("$HOME/.config/quickshell/scripts/ui-lang.sh")
if [ "$LANG_CODE" = "en" ]; then
    MSG="Screenshot saved"
else
    MSG="Captura guardada"
fi
notify-send -i "$OUT" "$MSG" "$OUT" 2>/dev/null || true
exit 0
