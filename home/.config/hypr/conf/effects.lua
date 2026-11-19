-- Look & feel: cristal rosa, aura suave, rendimiento contenido para Iris Xe.

hl.config({
    general = {
        gaps_in          = 4,
        gaps_out         = 10,
        border_size      = 2,
        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
        snap = {
            enabled      = true,
            window_gap   = 8,
            monitor_gap  = 8,
            border_overlap = true,
            respect_gaps = true,
        },
        col = {
            active_border = {
                colors = { Colors.pink, Colors.mauve },
                angle  = 45,
            },
            inactive_border = "rgba(3a3446aa)",
        },
    },

    decoration = {
        rounding       = 14,
        rounding_power = 3,

        active_opacity     = 0.97,
        inactive_opacity   = 0.93,
        fullscreen_opacity = 1.0,

        blur = {
            enabled            = true,
            size               = 6,
            passes             = 2,
            vibrancy           = 0.18,
            vibrancy_darkness  = 0.12,
            noise              = 0.015,
            contrast           = 0.95,
            brightness         = 0.92,
            ignore_opacity     = true,
            new_optimizations  = true,
            popups             = true,
            xray               = false,
        },

        shadow = {
            enabled      = false,
            range        = 18,
            render_power = 3,
            sharp        = true,
            color        = "rgba(0a0810aa)",
            offset       = { 0, 4 },
        },

        -- El "aura": halo rosa alrededor de la ventana activa.
        glow = {
            enabled      = true,
            range        = 10,
            render_power = 3,
            color        = "rgba(f5bde64d)",
            color_inactive = "rgba(f5bde61a)",
        },

        dim_inactive  = true,
        dim_strength  = 0.12,
        dim_special   = 0.35,
    },

    animations = {
        enabled              = true,
        workspace_wraparound = true,
    },

    dwindle = {
        preserve_split  = true,
        force_split     = 0,
        smart_split     = false,
    },

    master = {
        new_status = "master",
        mfact      = 0.55,
    },

    misc = {
        disable_hyprland_logo               = true,
        force_default_wallpaper             = 0,
        font_family                         = "JetBrainsMono Nerd Font",
        mouse_move_focuses_monitor          = false,
        focus_on_activate                   = true,
        animate_manual_resizes              = true,
        animate_mouse_windowdragging        = true,
        session_lock_blur                   = true,
        disable_autoreload                  = false,
    },

    binds = {
        workspace_back_and_forth = false,
        allow_workspace_cycles   = true,
        pass_mouse_when_bound    = false,
        focus_preferred_method   = 0,
        drag_threshold           = 10,
        hide_special_on_workspace_change = true,
    },

    cursor = {
        enable_hyprcursor     = true,
        sync_gsettings_theme  = false,
        no_warps              = false,
    },
})

--------------------------------------------------------------------------------
-- Curvas y animaciones
--------------------------------------------------------------------------------

hl.curve("auraOut",   { type = "bezier", points = { {0.16, 1},    {0.3, 1}     } })
hl.curve("auraIn",    { type = "bezier", points = { {0.7, 0},     {0.84, 0}    } })
hl.curve("auraSmooth",{ type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("auraSnap",  { type = "bezier", points = { {0.2, 0},     {0, 1}       } })
hl.curve("auraSpring",{ type = "spring", mass = 1, stiffness = 210, dampening = 22 })

hl.animation({ leaf = "global",        enabled = true,  speed = 8,    bezier = "auraSmooth" })
hl.animation({ leaf = "border",        enabled = true,  speed = 6,    bezier = "auraOut" })
hl.animation({ leaf = "borderangle",   enabled = true,  speed = 40,   bezier = "linear" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 5,    spring = "auraSpring" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 5.2,  spring = "auraSpring", style = "popin 92%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 3,    bezier = "auraIn",     style = "popin 85%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 3,    bezier = "auraOut" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 2.4,  bezier = "auraIn" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.2,  bezier = "auraSmooth" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 4,    bezier = "auraOut" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 5,    spring = "auraSpring", style = "popin 94%" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 2.8,  bezier = "auraIn",     style = "popin 90%" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 2.4,  bezier = "auraSmooth" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.8,  bezier = "auraSmooth" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 3.4,  bezier = "auraOut",    style = "slidefade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 3,    bezier = "auraOut",    style = "slidefade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 2.6,  bezier = "auraSmooth", style = "slidefade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "auraSnap" })

--------------------------------------------------------------------------------
-- Layer rules: blur para la barra y notificaciones
--------------------------------------------------------------------------------

hl.layer_rule({
    name  = "quickshell-blur",
    match = { namespace = "^quickshell$" },
    blur  = true,
    ignore_alpha = 0.2,
})

hl.layer_rule({
    name  = "dunst-blur",
    match = { namespace = "^notifications$" },
    blur  = true,
    ignore_alpha = 0.3,
})

hl.layer_rule({
    name  = "quickshell-wallpapers-noanim",
    match = { namespace = "^quickshell-wallpapers$" },
    no_anim = true,
})

hl.layer_rule({
    name  = "launcher-blur",
    match = { namespace = "^fuzzel$" },
    blur  = true,
    ignore_alpha = 0.2,
})
