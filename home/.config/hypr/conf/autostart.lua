-- Procesos que arrancan con la sesión de Hyprland.

hl.on("hyprland.start", function()
    -- Barra
    hl.exec_cmd("quickshell -n")

    -- Notificaciones e idle
    hl.exec_cmd("pgrep -x dunst >/dev/null || dunst")
    hl.exec_cmd("pgrep -x hypridle >/dev/null || hypridle")

    -- Portapapeles
    hl.exec_cmd("~/.config/hypr/scripts/clipboard-watch.sh")

    -- Fondo (restaura el elegido en Quickshell, o el default)
    hl.exec_cmd("~/.config/hypr/scripts/wallpaper.sh restore")
end)
