#!/usr/bin/env bash
# Instala Hypernight: dependencias primero y luego los dotfiles por symlinks.
#
# Uso:
#   ./install.sh [--dry-run] [--no-deps] [--deps-only]
#   curl -fsSL https://raw.githubusercontent.com/mAlkkXD/Hypernight/main/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- --dry-run
set -euo pipefail

REPO_URL="https://github.com/mAlkkXD/Hypernight.git"
SELF="${BASH_SOURCE[0]:-}"
REPO=""
DRY=0
WITH_DEPS=1
DEPS_ONLY=0

for arg in "$@"; do
    case "$arg" in
        --dry-run)   DRY=1 ;;
        --no-deps)   WITH_DEPS=0 ;;
        --deps-only) DEPS_ONLY=1 ;;
        -h|--help)
            sed -n '2,9p' "$0" 2>/dev/null || true
            exit 0 ;;
        *) echo "opción desconocida: $arg"; exit 2 ;;
    esac
done

DEST="$HOME"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$DEST/.dotfiles-backup/$STAMP"

# --------------------------------------------------------------- paquetes
PKGS=(
    git curl
    hyprland quickshell swaybg
    kitty dolphin pavucontrol
    dunst fuzzel cava btop starship fish
    matugen imagemagick python
    grim slurp swappy wl-clipboard cliphist hyprshot
    hypridle hyprlock wlogout
    networkmanager bluez bluez-utils
    brightnessctl playerctl lyrics-git
    pipewire wireplumber pipewire-pulse
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
    libnotify kvantum ttf-jetbrains-mono-nerd
)

need_root() {
    if [ "$(id -u)" = 0 ]; then
        "$@"
    elif command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        echo "Necesitas root o sudo para instalar paquetes." >&2
        return 1
    fi
}

install_pacman() {
    local missing=() aur=()
    for p in "${PKGS[@]}"; do
        pacman -Qq "$p" >/dev/null 2>&1 && continue
        if pacman -Sp "$p" >/dev/null 2>&1; then
            missing+=("$p")
        else
            aur+=("$p")
        fi
    done
    if [ "${#missing[@]}" -gt 0 ]; then
        echo "Instalando ${#missing[@]} paquetes: ${missing[*]}"
        if [ "$DRY" = 1 ]; then
            echo "  (dry-run) pacman -S --needed --noconfirm ${missing[*]}"
        else
            need_root pacman -S --needed --noconfirm "${missing[@]}"
        fi
    else
        echo "Dependencias de los repositorios: ya instaladas"
    fi
    if [ "${#aur[@]}" -gt 0 ]; then
        echo "En AUR: ${aur[*]}"
        local helper=""
        command -v yay >/dev/null 2>&1 && helper="yay"
        [ -z "$helper" ] && command -v paru >/dev/null 2>&1 && helper="paru"
        if [ -n "$helper" ]; then
            if [ "$DRY" = 1 ]; then
                echo "  (dry-run) $helper -S --needed --noconfirm ${aur[*]}"
            else
                "$helper" -S --needed --noconfirm "${aur[@]}"
            fi
        else
            echo "  instálalos a mano: ${aur[*]}"
        fi
    fi
}

install_apt() {
    local missing=()
    for p in "${PKGS[@]}"; do
        dpkg -s "$p" >/dev/null 2>&1 || missing+=("$p")
    done
    [ "${#missing[@]}" -eq 0 ] && { echo "Dependencias: ya instaladas"; return; }
    if [ "$DRY" = 1 ]; then
        echo "  (dry-run) apt-get install -y ${missing[*]}"
    else
        need_root apt-get update
        need_root apt-get install -y "${missing[@]}"
    fi
}

install_dnf() {
    local missing=()
    for p in "${PKGS[@]}"; do
        rpm -q "$p" >/dev/null 2>&1 || missing+=("$p")
    done
    [ "${#missing[@]}" -eq 0 ] && { echo "Dependencias: ya instaladas"; return; }
    if [ "$DRY" = 1 ]; then
        echo "  (dry-run) dnf install -y ${missing[*]}"
    else
        need_root dnf install -y "${missing[@]}"
    fi
}

install_zypper() {
    local missing=()
    for p in "${PKGS[@]}"; do
        rpm -q "$p" >/dev/null 2>&1 || missing+=("$p")
    done
    [ "${#missing[@]}" -eq 0 ] && { echo "Dependencias: ya instaladas"; return; }
    if [ "$DRY" = 1 ]; then
        echo "  (dry-run) zypper install -y ${missing[*]}"
    else
        need_root zypper --non-interactive install "${missing[@]}"
    fi
}

install_deps() {
    if command -v pacman >/dev/null 2>&1; then
        install_pacman
    elif command -v apt-get >/dev/null 2>&1; then
        install_apt
    elif command -v dnf >/dev/null 2>&1; then
        install_dnf
    elif command -v zypper >/dev/null 2>&1; then
        install_zypper
    else
        echo "No reconozco el gestor de paquetes. Instala a mano:" >&2
        printf '  %s\n' "${PKGS[@]}" >&2
        return 1
    fi
}

# --------------------------------------------------------------- repo
if [ -n "$SELF" ] && [ -f "$SELF" ]; then
    REPO="$(cd "$(dirname "$SELF")" && pwd)"
fi

if [ ! -f "$REPO/install.sh" ]; then
    # Ejecutado por pipe: hace falta git antes de clonar.
    if ! command -v git >/dev/null 2>&1; then
        echo "Instalando git..."
        case "$(command -v pacman apt-get dnf zypper 2>/dev/null | head -1)" in
            *pacman) need_root pacman -S --needed --noconfirm git ;;
            *apt-get) need_root apt-get update && need_root apt-get install -y git ;;
            *dnf) need_root dnf install -y git ;;
            *zypper) need_root zypper --non-interactive install git ;;
            *) echo "Instala git y vuelve a intentarlo." >&2; exit 1 ;;
        esac
    fi
    REPO="${HYPERNIGHT_DIR:-$HOME/Hypernight}"
    if [ -d "$REPO/.git" ]; then
        echo "Actualizando $REPO..."
        git -C "$REPO" pull --ff-only
    else
        echo "Clonando en $REPO..."
        git clone "$REPO_URL" "$REPO"
    fi
fi

# --------------------------------------------------------------- deps
if [ "$WITH_DEPS" = 1 ]; then
    echo "== Dependencias =="
    install_deps
fi

if [ "$DEPS_ONLY" = 1 ]; then
    echo "Dependencias listas."
    exit 0
fi

# --------------------------------------------------------------- enlaces
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

echo "== Dotfiles =="
for entry in "$REPO/home/.config/"*; do
    link "$entry" "$DEST/.config/$(basename "$entry")"
done

for f in .bashrc .zshrc; do
    [ -e "$REPO/home/$f" ] && link "$REPO/home/$f" "$DEST/$f"
done

link "$REPO/home/.local/bin/lyrics" "$DEST/.local/bin/lyrics"

link "$REPO/wallpapers/WPForDF" "$DEST/Imágenes/Wallpapers/WPForDF"

cat <<'EOF'

Listo.

Ajusta los monitores en ~/.config/hypr/conf/monitors.lua y el estado
de fondos en ~/.config/quickshell/wallpaper.json.

Opcional (no están en los repos oficiales): fuentes e iconos del rice
como candy-icons, mizuki-psekai-cursor y Google Sans Flex.
EOF
