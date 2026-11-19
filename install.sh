#!/usr/bin/env bash
# Instala los dotfiles de Hypernight con symlinks.
# Uso: ./install.sh [--dry-run]
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$DEST/.dotfiles-backup/$STAMP"
DRY=0
[ "${1:-}" = "--dry-run" ] && DRY=1

link() {
    local src="$1" dst="$2"
    if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
        echo "ok      $dst"
        return
    fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        echo "backup  $dst -> $BACKUP/"
        if [ "$DRY" = 0 ]; then
            mkdir -p "$BACKUP/$(dirname "${dst#$DEST/}")"
            mv "$dst" "$BACKUP/${dst#$DEST/}"
        fi
    fi
    echo "link    $dst -> $src"
    if [ "$DRY" = 0 ]; then
        mkdir -p "$(dirname "$dst")"
        ln -s "$src" "$dst"
    fi
}

for entry in "$REPO/home/.config/"*; do
    link "$entry" "$DEST/.config/$(basename "$entry")"
done

for f in .bashrc .zshrc; do
    [ -e "$REPO/home/$f" ] && link "$REPO/home/$f" "$DEST/$f"
done

link "$REPO/wallpapers/WPForDF" "$DEST/Imágenes/Wallpapers/WPForDF"

cat <<'EOF'

Listo. Dependencias principales:
  hyprland quickshell swaybg kitty dunst fuzzel cava btop matugen
  grim slurp swappy wl-clipboard cliphist hypridle hyprlock wlogout
  networkmanager bluez-utils brightnessctl playerctl

Ajusta los monitores en ~/.config/hypr/conf/monitors.lua y el estado
de fondos en ~/.config/quickshell/wallpaper.json.
EOF
