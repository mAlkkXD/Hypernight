-- Reglas de ventanas y capas.

--------------------------------------------------------------------------------
-- Ventanas flotantes útiles
--------------------------------------------------------------------------------
local floats = {
    "pavucontrol",
    "blueman-manager",
    "nm-connection-editor",
    "xdg-desktop-portal-gtk",
    "org.pulseaudio.pavucontrol",
    "gnome-calculator",
    "galculator",
    "firefox.*-.*-.*-.*", -- diálogos de Firefox (muy específico)
}

for _, cls in ipairs(floats) do
    hl.window_rule({
        name  = "float-" .. cls,
        match = { class = "^(" .. cls .. ")$" },
        float = true,
        size  = "900 600",
        center = true,
    })
end

-- Visores de imágenes y reproductores: flotan y se centran
hl.window_rule({ name = "float-imv",    match = { class = "^(imv|feh|loupe|eog)$" }, float = true, size = "1200 800", center = true })
hl.window_rule({ name = "float-mpv",    match = { class = "^(mpv|celluloid)$" },     float = true, size = "1280 720", center = true })


-- OpenCode y Discord: tiled normales, pero sin pedir maximize
hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })

-- Diálogos de archivos (portal GTK) al centro
hl.window_rule({
    name  = "file-chooser",
    match = { title = "^(Open File|Open Files|Save File|Select a File|Choose File)$" },
    float = true,
    center = true,
    size  = "1000 700",
})

-- XWayland drag fix
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true },
    no_focus = true,
})

-- Juegos: sin gaps ni blur cuando van fullscreen
hl.window_rule({
    name  = "games-noblur",
    match = { class = "^(steam_app_.*|gamescope|.*\\.exe)$" },
    opaque = true,
})

--------------------------------------------------------------------------------
-- Capas
--------------------------------------------------------------------------------
hl.layer_rule({ name = "wlogout-blur", match = { namespace = "^wlogout$" }, blur = true, ignore_alpha = 0.1 })
hl.layer_rule({ name = "hyprlock-blur", match = { namespace = "^hyprlock$" }, blur = true })
