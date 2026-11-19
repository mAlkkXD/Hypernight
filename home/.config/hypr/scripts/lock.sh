#!/usr/bin/env bash
# Pantalla de bloqueo con textos según el idioma de interfaz.
set -u

BASE="$HOME/.config/hypr/hyprlock.conf"
LANG_CODE=$("$HOME/.config/quickshell/scripts/ui-lang.sh")

if [ "$LANG_CODE" = "en" ]; then
    export LC_TIME=en_US.UTF-8
    CONF="${XDG_RUNTIME_DIR:-/tmp}/hyprlock-en.conf"
    sed \
        -e "s|%A, %d de %B|%A, %B %d|" \
        -e "s|>contraseña<|>password<|" \
        -e "s|falló, intenta de nuevo|failed, try again|" \
        -e "s|usuario:|user:|" \
        "$BASE" > "$CONF"
else
    export LC_TIME=es_MX.UTF-8
    CONF="$BASE"
fi

exec hyprlock -c "$CONF" "$@"
