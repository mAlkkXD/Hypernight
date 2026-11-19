-- Generado por el Control Center de Quickshell. No editar a mano.
hl.config({
    general = {
        col = {
            active_border = { colors = { "rgba(c4e1e9ff)", "rgba(d6eaf0ff)" }, angle = 45 },
        },
    },
    decoration = {
        glow = {
            color = "rgba(c4e1e94d)",
            color_inactive = "rgba(c4e1e91a)",
        },
    },
    input = {
        kb_layout = "us,latam",
    },
})

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprctl switchxkblayout all 0")
end)
