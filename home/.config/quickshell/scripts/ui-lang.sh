#!/usr/bin/env bash
# Devuelve el idioma de interfaz elegido en el Control Center ("en" o "es").
set -u

SETTINGS="$HOME/.config/quickshell/settings.json"

lang="es"
if [ -r "$SETTINGS" ]; then
    value=$(jq -r '.uiLanguage // empty' "$SETTINGS" 2>/dev/null)
    if [ "$value" = "en" ] || [ "$value" = "es" ]; then
        lang="$value"
    fi
fi

printf '%s\n' "$lang"
