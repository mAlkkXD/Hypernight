#!/usr/bin/env bash
# Lanzador de aplicaciones (fuzzel) con textos según el idioma de interfaz.
set -u

LANG_CODE=$("$HOME/.config/quickshell/scripts/ui-lang.sh")

case "$LANG_CODE" in
    en)
        placeholder="Search application..."
        export LC_MESSAGES=en_US.UTF-8
        export LANGUAGE=en_US:en
        ;;
    *)
        placeholder="Buscar aplicación..."
        export LC_MESSAGES=es_MX.UTF-8
        export LANGUAGE=es_MX:es
        ;;
esac

exec fuzzel --placeholder "$placeholder" "$@"
