-- Atajos. SUPER como modificador principal.

local mod = "SUPER"
local term = "kitty"
local files = "dolphin"
local menu = "~/.config/quickshell/scripts/launcher.sh"

local function sh(c) return hl.dsp.exec_cmd(c) end

--------------------------------------------------------------------------------
-- Apps
--------------------------------------------------------------------------------
hl.bind(mod .. " + Return",      sh(term))
hl.bind(mod .. " + Q",           hl.dsp.window.close())
hl.bind(mod .. " + E",           sh(files))
hl.bind(mod .. " + R",           sh(menu))
hl.bind(mod .. " + A",           sh("pavucontrol"))
hl.bind(mod .. " + ALT + L",     sh("~/.config/hypr/scripts/lock.sh"))
hl.bind(mod .. " + Escape",      sh("wlogout --protocol layer-shell -l ~/.config/hypr/wlogout/layout -C ~/.config/hypr/wlogout/style.css -b 5"))
hl.bind(mod .. " + N",           sh("dunstctl history-pop"))
hl.bind(mod .. " + SHIFT + N",   sh("dunstctl close-all"))
hl.bind(mod .. " + V",           sh("~/.config/hypr/scripts/clipboard.sh"))
hl.bind(mod .. " + X",           sh("quickshell ipc call cc toggle"))
hl.bind(mod .. " + W",           sh("quickshell ipc call cc wallpaper"))

--------------------------------------------------------------------------------
-- Foco (flechas y hjkl)
--------------------------------------------------------------------------------
hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "d" }))

hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))

--------------------------------------------------------------------------------
-- Mover / redimensionar ventanas
--------------------------------------------------------------------------------
hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))

hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

hl.bind(mod .. " + CTRL + left",  hl.dsp.window.resize({ x = -24, y = 0, relative = true }))
hl.bind(mod .. " + CTRL + right", hl.dsp.window.resize({ x = 24,  y = 0, relative = true }))
hl.bind(mod .. " + CTRL + up",    hl.dsp.window.resize({ x = 0,   y = -24, relative = true }))
hl.bind(mod .. " + CTRL + down",  hl.dsp.window.resize({ x = 0,   y = 24, relative = true }))

hl.bind(mod .. " + CTRL + H", hl.dsp.window.resize({ x = -24, y = 0, relative = true }))
hl.bind(mod .. " + CTRL + L", hl.dsp.window.resize({ x = 24,  y = 0, relative = true }))
hl.bind(mod .. " + CTRL + K", hl.dsp.window.resize({ x = 0,   y = -24, relative = true }))
hl.bind(mod .. " + CTRL + J", hl.dsp.window.resize({ x = 0,   y = 24, relative = true }))

hl.bind(mod .. " + CTRL + S",  hl.dsp.window.swap({ direction = "r" }))

--------------------------------------------------------------------------------
-- Estado de ventana
--------------------------------------------------------------------------------
hl.bind(mod .. " + F",            hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mod .. " + SHIFT + F",    hl.dsp.window.fullscreen({ mode = "maximized",  action = "toggle" }))
hl.bind(mod .. " + Space",        hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + SHIFT + Space",hl.dsp.window.pin({ action = "toggle" }))
hl.bind(mod .. " + P",            hl.dsp.window.pseudo({ action = "toggle" }))
hl.bind(mod .. " + O",            hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + TAB",          hl.dsp.window.cycle_next({ next = true }))
hl.bind(mod .. " + SHIFT + TAB",  hl.dsp.window.cycle_next({ next = false }))
hl.bind(mod .. " + C",            hl.dsp.window.center())
hl.bind(mod .. " + G",            hl.dsp.group.toggle())
hl.bind(mod .. " + SHIFT + G",    hl.dsp.group.next())
hl.bind(mod .. " + ALT + G",      hl.dsp.group.prev())

--------------------------------------------------------------------------------
-- Workspaces
--------------------------------------------------------------------------------
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = true }))
end

-- Teclado numérico: mismas acciones que la fila de números.
-- Se cubren ambos estados de NumLock: encendido (KP_1..KP_0) y apagado
-- (KP_End, KP_Down, KP_Next, KP_Left, KP_Begin, KP_Right, KP_Home,
-- KP_Up, KP_Prior, KP_Insert).
local numpadKeys = {
    { "KP_1", "KP_End" },
    { "KP_2", "KP_Down" },
    { "KP_3", "KP_Next" },
    { "KP_4", "KP_Left" },
    { "KP_5", "KP_Begin" },
    { "KP_6", "KP_Right" },
    { "KP_7", "KP_Home" },
    { "KP_8", "KP_Up" },
    { "KP_9", "KP_Prior" },
    { "KP_0", "KP_Insert" },
}

for ws, keys in ipairs(numpadKeys) do
    for _, key in ipairs(keys) do
        hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = ws }))
        hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws, follow = true }))
    end
end

hl.bind(mod .. " + ALT + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + ALT + left",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse_down",   hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",     hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

--------------------------------------------------------------------------------
-- Mouse
--------------------------------------------------------------------------------
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--------------------------------------------------------------------------------
-- Layout de teclado: Alt+Shift alterna US/LATAM (xkb nativo)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Multimedia
--------------------------------------------------------------------------------
hl.bind("XF86AudioRaiseVolume", sh("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", sh("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        sh("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     sh("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  sh("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",sh("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  sh("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", sh("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  sh("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  sh("playerctl previous"),   { locked = true })

--------------------------------------------------------------------------------
-- Capturas
--------------------------------------------------------------------------------
hl.bind("PRINT",              sh("~/.config/hypr/scripts/screenshot.sh region"))
hl.bind("SHIFT + PRINT",      sh("~/.config/hypr/scripts/screenshot.sh full"))
hl.bind("ALT + PRINT",        sh("~/.config/hypr/scripts/screenshot.sh window"))
hl.bind(mod .. " + PRINT",    sh("~/.config/hypr/scripts/screenshot.sh region"))
hl.bind(mod .. " + SHIFT + PRINT", sh("~/.config/hypr/scripts/screenshot.sh full"))

--------------------------------------------------------------------------------
-- Utilidades del config
--------------------------------------------------------------------------------
hl.bind(mod .. " + ALT + R", sh("hyprctl reload"))
hl.bind(mod .. " + ALT + W", sh("~/.config/hypr/scripts/recolor.sh"))
