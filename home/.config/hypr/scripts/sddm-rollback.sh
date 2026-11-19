#!/usr/bin/env bash
# Revierte la configuración de SDDM (2026-11-07) y vuelve al arranque en TTY.
# Uso: bash ~/.config/hypr/scripts/sddm-rollback.sh
set -euo pipefail

TS="20261107-223229"

say() { printf '\n== %s\n' "$*"; }

say "Quitando config de SDDM"
sudo rm -f /etc/sddm.conf.d/10-malkkxd.conf
if [ -f "/etc/sddm.conf.d/x11.conf.bak-$TS.disabled" ]; then
    sudo mv "/etc/sddm.conf.d/x11.conf.bak-$TS.disabled" /etc/sddm.conf.d/x11.conf
fi

say "Restaurando GRUB (devuelve splash)"
sudo cp "/etc/default/grub.bak-$TS" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

say "Volviendo al arranque en TTY"
sudo systemctl set-default multi-user.target
sudo systemctl enable getty@tty1

say "Hecho. Reinicia para volver al estado anterior."
say "El tema sigue en /usr/share/sddm/themes/malkkxd; bórralo si quieres."
