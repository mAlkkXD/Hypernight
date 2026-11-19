-- Input: US + LATAM alternables con Alt+Shift o Super+Alt+K.

hl.config({
    input = {
        kb_layout  = "us,latam",
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:alt_shift_toggle",
        kb_rules   = "",

        follow_mouse      = 1,
        sensitivity       = -0.2,
        accel_profile     = "adaptive",
        numlock_by_default = false,
        repeat_delay      = 300,
        repeat_rate       = 40,

        touchpad = {
            natural_scroll     = true,
            tap_to_click       = true,
            tap_and_drag       = true,
            drag_lock          = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
            middle_button_emulation = true,
        },
    },
})

-- Gestos de touchpad
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "up",         action = "fullscreen" })
hl.gesture({ fingers = 4, direction = "down",       action = "float" })

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Adwaita")

-- Apps lanzadas desde Hyprland hablan Wayland nativo.
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Permisos del ecosistema (Hyprland 0.56)
hl.permission({ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/hyprshot", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/lib/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/hyprlock", type = "screencopy", mode = "allow" })

