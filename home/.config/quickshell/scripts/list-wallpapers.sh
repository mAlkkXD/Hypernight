#!/usr/bin/env bash
# Lista los wallpapers y genera miniaturas hexagonales cacheadas.
# Salida: una línea por imagen con "nombre<TAB>ruta<TAB>miniatura".
set -u

DIR="$HOME/Imágenes/Wallpapers"
CACHE="$HOME/.cache/quickshell/wallpapers"
MASK="$CACHE/hex-mask.png"

# Hexágono regular acostado: lados planos arriba/abajo, picos izquierda/derecha.
# Proporción 720x624 (alto = ancho * sqrt(3)/2).
mkdir -p "$CACHE"
if [ ! -f "$MASK" ]; then
    magick -size 720x624 xc:none -fill white \
        -draw "polygon 0,312 180,0 540,0 720,312 540,624 180,624" \
        "$MASK"
fi

[ -d "$DIR" ] || exit 0

while IFS= read -r src; do
    [ -n "$src" ] || continue
    id=$(printf '%s' "$src" | md5sum | cut -d' ' -f1)
    thumb="$CACHE/$id.png"

    if [ ! -f "$thumb" ] || [ "$src" -nt "$thumb" ]; then
        magick "$src[0]" -auto-orient -resize 720x624^ -gravity center \
            -extent 720x624 "$MASK" -alpha off -compose CopyOpacity \
            -composite "$thumb" 2>/dev/null || continue
    fi

    name=$(basename "$src")
    name="${name%.*}"
    printf '%s\t%s\t%s\n' "$name" "$src" "$thumb"
done < <(find "$DIR" -maxdepth 2 -type f \
         \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \
            -o -iname '*.webp' -o -iname '*.gif' \) | sort -V)
