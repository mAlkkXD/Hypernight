-- Hyprland 0.56 — config Lua
-- "Mocha Rosita": rosa como acento, neutros con tinte malva.
--
-- Estructura:
--   conf/colors.lua     paleta
--   conf/monitors.lua   pantallas y workspaces
--   conf/effects.lua    decoración, blur, glow, animaciones
--   conf/input.lua      teclado, touchpad, gestos
--   conf/keybinds.lua   atajos
--   conf/rules.lua      reglas de ventana y capas
--   conf/autostart.lua  procesos al iniciar

require("conf.colors")
require("conf.monitors")
require("conf.effects")
require("conf.input")
require("conf.keybinds")
require("conf.rules")
require("conf.autostart")
require("conf.control-center")
