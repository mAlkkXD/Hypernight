#!/usr/bin/env bash
# Menú de energía (wlogout) con etiquetas según el idioma de interfaz.
set -u

LANG_CODE=$("$HOME/.config/quickshell/scripts/ui-lang.sh")

case "$LANG_CODE" in
    en) layout="$HOME/.config/hypr/wlogout/layout.en" ;;
    *)  layout="$HOME/.config/hypr/wlogout/layout" ;;
esac

exec wlogout --protocol layer-shell -l "$layout" -C "$HOME/.config/hypr/wlogout/style.css" -b 5 "$@"
