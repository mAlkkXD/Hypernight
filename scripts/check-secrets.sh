#!/usr/bin/env bash
# Escanea el repo en busca de secretos. Devuelve 1 si encuentra algo.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 1

fail=0

scan() {
    local label="$1" pattern="$2"
    local hits
    hits=$(grep -rInE --binary-files=without-match --exclude-dir=.git \
        --exclude-dir=node_modules -- "$pattern" . 2>/dev/null || true)
    if [ -n "$hits" ]; then
        echo "posible secreto ($label):"
        echo "$hits" | sed -E 's/([=:]).*/\1 [oculto]/'
        fail=1
    fi
}

scan "openai"      'sk-[A-Za-z0-9_-]{20,}'
scan "github pat"  'ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}'
scan "google api"  'AIza[0-9A-Za-z_-]{30,}'
scan "slack"       'xox[baprs]-[A-Za-z0-9-]{10,}'
scan "aws"         'AKIA[0-9A-Z]{16}'
scan "gitlab"      'glpat-[A-Za-z0-9_-]{20,}'
scan "huggingface" 'hf_[A-Za-z0-9]{20,}'
scan "private key" '-----BEGIN [A-Z ]*PRIVATE KEY-----'

# Cadenas locales que nunca deben subirse. El archivo no está en el repo.
DENY="$HOME/.config/hypernight/deny.txt"
if [ -f "$DENY" ]; then
    while IFS= read -r s; do
        [ -z "$s" ] && continue
        hits=$(grep -rInF --binary-files=without-match --exclude-dir=.git -- "$s" . 2>/dev/null || true)
        if [ -n "$hits" ]; then
            echo "cadena prohibida encontrada:"
            echo "$hits"
            fail=1
        fi
    done < "$DENY"
fi

if [ "$fail" = 0 ]; then
    echo "sin secretos detectados"
fi
exit "$fail"
