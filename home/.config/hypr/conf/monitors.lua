-- Monitores: externo (HDMI) a la izquierda, laptop (eDP-1) a la derecha.
-- Escala 1.25 en ambos => 1536x864 lógicos por pantalla.

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "preferred",
    position = "-1536x0",
    scale    = 1.25,
})

hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "0x0",
    scale    = 1.25,
})

-- Workspaces fijos por monitor: 1-5 en el laptop, 6-10 en el externo.
-- persistent + default: existen desde el arranque en su monitor y no pueden
-- nacer en el monitor equivocado al mover ventanas.
for i = 1, 5 do
    hl.workspace_rule({
        workspace  = tostring(i),
        monitor    = "eDP-1",
        default    = true,
        persistent = true,
    })
end

for i = 6, 10 do
    hl.workspace_rule({
        workspace  = tostring(i),
        monitor    = "HDMI-A-1",
        default    = true,
        persistent = true,
    })
end

-- El especial "magic" (scratchpad) flota sobre el monitor activo.
hl.workspace_rule({ workspace = "special:magic", gaps_out = 30, gaps_in = 6 })
