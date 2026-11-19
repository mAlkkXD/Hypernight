import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.SystemTray
import Quickshell.Bluetooth
import Quickshell.Services.Mpris

ShellRoot {
    id: root

    property var theme: ({
        bg: "#1e1b22",
        bgAlt: "#251d22",
        surface: "#2a2633",
        surfaceHigh: "#35303f",
        text: "#e8e2ee",
        subtext: "#b8aec6",
        outline: "#9e8c96",
        accent: "#f5bde6",
        accentSoft: "#f7d6e8",
        mauve: "#cba6f7",
        red: "#f38ba8",
        yellow: "#f9e2af",
        green: "#a6e3a1",
        blue: "#89b4fa"
    })

    property var fullscreenMonitors: ({})
    property var cavaValues: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    property real cpuUsage: 0
    property real memUsage: 0
    property int gpuUsage: 0
    property int batteryLevel: 0
    property bool charging: false
    property int volumePercent: 0
    property bool volumeMuted: false
    property var audioSinks: []
    property var audioSources: []
    property string audioDefaultSink: ""
    property string audioDefaultSource: ""
    property var prevCpu: ({ total: 0, idle: 0 })

    readonly property string mono: "JetBrainsMono Nerd Font"

    function alpha(hex, a) {
        if (!hex || hex.length < 7)
            return Qt.rgba(0, 0, 0, a)
        return Qt.rgba(parseInt(hex.substr(1, 2), 16) / 255,
                       parseInt(hex.substr(3, 2), 16) / 255,
                       parseInt(hex.substr(5, 2), 16) / 255,
                       a)
    }

    // ---------------------------------------------------------- acento
    property string accentMode: "manual"
    property string accentAutoColor: ""
    property bool accentInitialized: false
    property int keyboardLayoutIndex: 0
    property string uiLanguage: "es"
    property bool uiLanguageInitialized: false

    readonly property var uiStrings: ({
        es: {
            "media.none": "Sin reproducción",
            "media.hint": "Abre un reproductor compatible",
            "toggles.wifi": "Wi-Fi",
            "toggles.bt": "Bluetooth",
            "toggles.dnd": "No molestar",
            "toggles.awake": "Despierto",
            "toggles.lock": "Bloquear",
            "toggles.shot": "Captura",
            "toggles.on": "Encendido",
            "toggles.off": "Apagado",
            "toggles.active": "Activo",
            "toggles.muted": "Silenciado",
            "toggles.normal": "Normal",
            "toggles.screen": "Pantalla",
            "toggles.region": "Región",
            "accent.title": "Acento",
            "accent.auto": "Automático",
            "accent.manual": "Manual",
            "accent.autoHint": "Automático desde el wallpaper",
            "wallpaper.title": "Fondo",
            "wallpaper.change": "Cambiar fondo",
            "lang.kbTitle": "Idioma del teclado",
            "lang.uiTitle": "Idioma de la interfaz",
            "lang.english": "English",
            "lang.spanish": "Español",
            "cal.today": "hoy",
            "status.pairing": "Emparejando...",
            "status.connecting": "Conectando...",
            "status.disconnecting": "Desconectando...",
            "status.connected": "Conectado",
            "status.paired": "Emparejado",
            "status.available": "Disponible",
            "status.adapter": "Adaptador",
            "status.noAdapter": "Sin adaptador",
            "audio.title": "Audio",
            "audio.output": "SALIDA",
            "audio.input": "ENTRADA",
            "audio.outputLine": "Salida: ",
            "audio.inputLine": "Entrada: ",
            "audio.silenced": "Silenciado",
            "audio.noOutput": "Sin salida",
            "audio.noInput": "Sin entrada",
            "audio.noOutputs": "No hay dispositivos de salida",
            "audio.noInputs": "No hay dispositivos de entrada",
            "audio.clickDefault": "Clic para usar como predeterminado",
            "audio.analogStereo": "estéreo",
            "bt.title": "Bluetooth",
            "bt.searching": "Buscando dispositivos...",
            "bt.off": "Bluetooth apagado",
            "bt.noDevices": "No hay dispositivos",
            "bt.scan": "Buscar dispositivos",
            "bt.stopScan": "Detener búsqueda",
            "bt.connect": "Conectar",
            "bt.disconnect": "Desconectar",
            "bt.cancel": "Cancelar",
            "bt.pair": "Emparejar"
        },
        en: {
            "media.none": "Nothing playing",
            "media.hint": "Open a compatible player",
            "toggles.wifi": "Wi-Fi",
            "toggles.bt": "Bluetooth",
            "toggles.dnd": "DND",
            "toggles.awake": "Awake",
            "toggles.lock": "Lock",
            "toggles.shot": "Screenshot",
            "toggles.on": "On",
            "toggles.off": "Off",
            "toggles.active": "Active",
            "toggles.muted": "Muted",
            "toggles.normal": "Normal",
            "toggles.screen": "Screen",
            "toggles.region": "Region",
            "accent.title": "Accent",
            "accent.auto": "Automatic",
            "accent.manual": "Manual",
            "accent.autoHint": "Automatic from wallpaper",
            "wallpaper.title": "Wallpaper",
            "wallpaper.change": "Change wallpaper",
            "lang.kbTitle": "Keyboard language",
            "lang.uiTitle": "Interface language",
            "lang.english": "English",
            "lang.spanish": "Spanish",
            "cal.today": "today",
            "status.pairing": "Pairing...",
            "status.connecting": "Connecting...",
            "status.disconnecting": "Disconnecting...",
            "status.connected": "Connected",
            "status.paired": "Paired",
            "status.available": "Available",
            "status.adapter": "Adapter",
            "status.noAdapter": "No adapter",
            "audio.title": "Audio",
            "audio.output": "OUTPUT",
            "audio.input": "INPUT",
            "audio.outputLine": "Output: ",
            "audio.inputLine": "Input: ",
            "audio.silenced": "Muted",
            "audio.noOutput": "No output",
            "audio.noInput": "No input",
            "audio.noOutputs": "No output devices",
            "audio.noInputs": "No input devices",
            "audio.clickDefault": "Click to set as default",
            "audio.analogStereo": "analog stereo",
            "bt.title": "Bluetooth",
            "bt.searching": "Searching for devices...",
            "bt.off": "Bluetooth off",
            "bt.noDevices": "No devices found",
            "bt.scan": "Scan for devices",
            "bt.stopScan": "Stop scanning",
            "bt.connect": "Connect",
            "bt.disconnect": "Disconnect",
            "bt.cancel": "Cancel",
            "bt.pair": "Pair"
        }
    })

    readonly property var uiWeekdays: root.uiLanguage === "en"
        ? ["M", "T", "W", "T", "F", "S", "S"]
        : ["L", "M", "X", "J", "V", "S", "D"]

    readonly property var accentPresets: [
        "#f5bde6", "#cba6f7", "#89b4fa", "#94e2d5",
        "#a6e3a1", "#f9e2af", "#f38ba8"
    ]

    function mixWhite(hex, amount) {
        const r = parseInt(hex.substr(1, 2), 16)
        const g = parseInt(hex.substr(3, 2), 16)
        const b = parseInt(hex.substr(5, 2), 16)
        const mix = c => Math.round(c + (255 - c) * amount)
        return "#" + [mix(r), mix(g), mix(b)]
            .map(c => c.toString(16).padStart(2, "0")).join("")
    }

    function applyAccent(hex, mode) {
        const nextMode = mode || root.accentMode
        root.accentMode = nextMode
        let t
        try {
            t = JSON.parse(themeFile.text())
        } catch (e) {
            t = Object.assign({}, root.theme)
        }
        const soft = root.mixWhite(hex, 0.30)
        t.accent = hex
        t.accentSoft = soft
        t.accentDim = hex + "33"
        t.accentMode = nextMode
        root.theme = t
        themeFile.setText(JSON.stringify(t, null, 4) + "\n")
        root.applyHyprAccent(hex, soft)
    }

    function setAccent(hex) {
        root.applyAccent(hex, "manual")
    }

    function useAutoAccent() {
        root.accentMode = "auto"
        if (!accentProc.running)
            accentProc.running = true
    }

    function onWallpaperChanged() {
        wallpaperFile.reload()
        if (root.accentMode === "auto")
            accentDebounce.restart()
    }

    // --------------------------------------------------- hyprland: acento
    function hyprStateText(hex, soft, layoutIndex) {
        const a = hex.substr(1)
        const b = soft.substr(1)
        return "-- Generado por el Control Center de Quickshell. No editar a mano.\n"
             + "hl.config({\n"
             + "    general = {\n"
             + "        col = {\n"
             + "            active_border = { colors = { \"rgba(" + a + "ff)\", \"rgba(" + b + "ff)\" }, angle = 45 },\n"
             + "        },\n"
             + "    },\n"
             + "    decoration = {\n"
             + "        glow = {\n"
             + "            color = \"rgba(" + a + "4d)\",\n"
             + "            color_inactive = \"rgba(" + a + "1a)\",\n"
             + "        },\n"
             + "    },\n"
             + "    input = {\n"
             + "        kb_layout = \"us,latam\",\n"
             + "    },\n"
             + "})\n"
             + "\n"
             + "hl.on(\"hyprland.start\", function()\n"
             + "    hl.exec_cmd(\"hyprctl switchxkblayout all " + layoutIndex + "\")\n"
             + "end)\n"
    }

    function writeHyprState(hex, soft, layoutIndex) {
        const accent = hex || root.theme.accent
        const accentSoft = soft || root.mixWhite(accent, 0.30)
        const idx = layoutIndex === undefined ? root.keyboardLayoutIndex : layoutIndex
        hyprStateFile.setText(root.hyprStateText(accent, accentSoft, idx))
    }

    function applyHyprAccent(hex, soft) {
        const a = hex.substr(1)
        const b = soft.substr(1)
        const code = 'hl.config({ general = { col = { active_border = { colors = { "rgba('
                   + a + 'ff)", "rgba(' + b + 'ff)" }, angle = 45 } } }, decoration = { glow = { color = "rgba('
                   + a + '4d)", color_inactive = "rgba(' + a + '1a)" } } })'
        hyprAccentProc.command = ["hyprctl", "eval", code]
        hyprAccentProc.running = true
        root.writeHyprState(hex, soft)
    }

    function setKeyboardLayout(index) {
        root.keyboardLayoutIndex = index
        kbSetProc.command = ["hyprctl", "switchxkblayout", "all", String(index)]
        kbSetProc.running = true
        root.writeHyprState(root.theme.accent, root.theme.accentSoft, index)
    }

    function refreshKeyboardLayout() {
        if (!kbLayoutProc.running)
            kbLayoutProc.running = true
    }

    function t(key) {
        const table = root.uiStrings[root.uiLanguage] || root.uiStrings.es
        const value = table[key]
        return value === undefined ? key : value
    }

    function setUiLanguage(lang) {
        if (lang !== "en" && lang !== "es")
            return
        root.uiLanguage = lang
        root.uiLanguageInitialized = true
        let s = {}
        try {
            s = JSON.parse(settingsFile.text())
        } catch (e) {
        }
        s.uiLanguage = lang
        settingsFile.setText(JSON.stringify(s, null, 4) + "\n")
    }

    // -------------------------------------------------- selector de fondos
    property bool wpOpen: false
    property bool wpVisible: false
    property bool wpEntered: false
    property string wpMonitor: ""
    property var wallpapers: []
    property var wallpaperState: ({})

    function parseWallpaperState(text) {
        try {
            const s = JSON.parse(text)
            return (s && typeof s === "object") ? s : ({})
        } catch (e) {
            return ({})
        }
    }

    function parseWallpaperList(text) {
        const out = []
        const lines = String(text || "").split("\n")
        for (let i = 0; i < lines.length; i++) {
            const line = lines[i]
            if (line.length === 0)
                continue
            const parts = line.split("\t")
            if (parts.length < 3)
                continue
            out.push({ name: parts[0], path: parts[1], thumb: parts[2] })
        }
        return out
    }

    function wallpaperFor(monitorName) {
        let s = root.wallpaperState || ({})
        try {
            const parsed = JSON.parse(wallpaperFile.text())
            if (parsed && typeof parsed === "object")
                s = parsed
        } catch (e) {
        }
        const per = s.monitors || ({})
        return per[monitorName] || s.default || ""
    }

    function openWallpapers(monitorName) {
        root.ccOpen = false
        root.wpMonitor = (monitorName && monitorName.length > 0)
                        ? monitorName
                        : (Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : "")
        root.wpEntered = false
        root.wpOpen = true
        root.wpVisible = true
        wpEnterTimer.restart()
        if (!wpListProc.running)
            wpListProc.running = true
    }

    function applyWallpaper(path, monitorName) {
        if (!path || !monitorName)
            return
        let s = {}
        try {
            s = JSON.parse(wallpaperFile.text())
        } catch (e) {
            s = {}
        }
        if (!s || typeof s !== "object")
            s = {}
        s.mode = "per-monitor"
        if (!s.monitors || typeof s.monitors !== "object")
            s.monitors = {}
        s.monitors[monitorName] = path
        if (!s.default)
            s.default = path
        root.wallpaperState = s
        wallpaperFile.setText(JSON.stringify(s, null, 4) + "\n")
        wpApplyProc.command = ["bash", "/home/malkkxd/.config/hypr/scripts/wallpaper.sh", monitorName]
        wpApplyProc.running = true
        root.wpOpen = false
    }

    function randomWallpaper() {
        if (root.wallpapers.length === 0)
            return
        const pick = root.wallpapers[Math.floor(Math.random() * root.wallpapers.length)]
        root.applyWallpaper(pick.path, root.wpMonitor)
    }

    // Hexágonos regulares acostados (planos arriba/abajo, picos a los lados).
    function hexLayoutFor(count, availW, availH) {
        const empty = { items: [], radius: 0 }
        if (count <= 0 || availW <= 0 || availH <= 0)
            return empty

        const ratio = Math.sqrt(3) / 2
        let radius = Math.min(availW / 4.6, availH / 2.9, 230)
        let hexW = 0, hexH = 0, rows = 1, cols = 1, totalW = 0, totalH = 0

        for (let step = 0; step < 60; step++) {
            hexW = 2 * radius
            hexH = hexW * ratio
            rows = Math.max(1, Math.floor((availH - hexH / 2) / hexH))
            cols = Math.ceil(count / rows)
            totalW = hexW + (cols - 1) * 1.5 * radius
            totalH = rows * hexH + hexH / 2
            if (totalW <= availW && totalH <= availH)
                break
            radius *= 0.95
        }

        const ox = (availW - totalW) / 2
        const oy = (availH - totalH) / 2
        const items = []
        for (let i = 0; i < count; i++) {
            const col = Math.floor(i / rows)
            const row = i % rows
            items.push({
                x: ox + col * 1.5 * radius,
                y: oy + row * hexH + (col % 2 ? hexH / 2 : 0),
                w: hexW,
                h: hexH
            })
        }
        return { items: items, radius: radius }
    }

    function batteryIcon() {
        if (root.charging)
            return "\uf0e7"
        if (root.batteryLevel >= 90)
            return "\uf240"
        if (root.batteryLevel >= 65)
            return "\uf241"
        if (root.batteryLevel >= 40)
            return "\uf242"
        if (root.batteryLevel >= 15)
            return "\uf243"
        return "\uf244"
    }

    function btIconFor(d) {
        if (!d)
            return "\uf293"
        if (d.icon === "audio-headset" || d.icon === "audio-headphones")
            return "\uf025"
        if (d.icon === "input-gaming")
            return "\uf11b"
        if (d.icon === "input-keyboard")
            return "\uf11c"
        if (d.icon === "phone")
            return "\uf10b"
        return "\uf293"
    }

    function btStatusFor(d) {
        if (!d)
            return ""
        if (d.pairing)
            return root.t("status.pairing")
        if (d.state === BluetoothDeviceState.Connecting)
            return root.t("status.connecting")
        if (d.state === BluetoothDeviceState.Disconnecting)
            return root.t("status.disconnecting")
        if (d.connected)
            return root.t("status.connected")
        if (d.paired)
            return root.t("status.paired")
        return root.t("status.available")
    }

    // ---------------------------------------------------------------- tema
    FileView {
        id: themeFile
        path: "/home/malkkxd/.config/quickshell/theme.json"
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try {
                const t = JSON.parse(themeFile.text())
                if (t && t.accent)
                    root.theme = t
                if (!root.accentInitialized && t) {
                    root.accentInitialized = true
                    root.accentMode = t.accentMode === "auto" ? "auto" : "manual"
                    root.applyHyprAccent(t.accent, t.accentSoft || root.mixWhite(t.accent, 0.30))
                    root.refreshKeyboardLayout()
                    accentStartTimer.start()
                }
            } catch (e) {
                console.warn("theme.json invalido:", e)
            }
        }
    }

    Process {
        id: accentProc
        command: ["/home/malkkxd/.config/quickshell/scripts/accent-from-wallpaper.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                const c = this.text.trim()
                if (!/^#[0-9a-fA-F]{6}$/.test(c))
                    return
                root.accentAutoColor = c
                if (root.accentMode === "auto")
                    root.applyAccent(c, "auto")
            }
        }
    }

    Timer {
        id: accentStartTimer
        interval: 900
        repeat: false
        onTriggered: if (!accentProc.running)
            accentProc.running = true
    }

    Timer {
        id: accentDebounce
        interval: 500
        repeat: false
        onTriggered: if (!accentProc.running)
            accentProc.running = true
    }

    FileView {
        id: wallpaperFile
        path: "/home/malkkxd/.config/quickshell/wallpaper.json"
        watchChanges: true
        onFileChanged: root.onWallpaperChanged()
        onLoaded: root.wallpaperState = root.parseWallpaperState(wallpaperFile.text())
    }

    // ------------------------------------------ hyprland: estado del acento
    FileView {
        id: hyprStateFile
        path: "/home/malkkxd/.config/hypr/conf/control-center.lua"
        preload: true
    }

    FileView {
        id: settingsFile
        path: "/home/malkkxd/.config/quickshell/settings.json"
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try {
                const s = JSON.parse(settingsFile.text())
                if (!root.uiLanguageInitialized
                        && (s.uiLanguage === "en" || s.uiLanguage === "es")) {
                    root.uiLanguage = s.uiLanguage
                    root.uiLanguageInitialized = true
                }
            } catch (e) {
            }
        }
    }

    Process {
        id: hyprAccentProc
        command: ["true"]
    }

    Process {
        id: kbSetProc
        command: ["true"]
        onExited: root.refreshKeyboardLayout()
    }

    Process {
        id: kbLayoutProc
        command: ["hyprctl", "-j", "devices"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const d = JSON.parse(this.text)
                    const list = d.keyboards || []
                    const main = list.find(k => k.main === true)
                                 || list.find(k => k.layout && k.layout.length > 0)
                    if (main) {
                        const i = Number(main.active_layout_index)
                        if (!isNaN(i) && i >= 0)
                            root.keyboardLayoutIndex = i
                    }
                } catch (e) {
                }
            }
        }
    }

    Timer {
        interval: 2500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refreshKeyboardLayout()
    }

    // ------------------------------------------------------- cpu / ram
    FileView {
        id: statFile
        path: "/proc/stat"
        onLoaded: {
            const line = statFile.text().split("\n")[0].trim().split(/\s+/)
            const vals = line.slice(1).map(Number)
            const idle = vals[3] + (vals[4] || 0)
            const total = vals.reduce((a, b) => a + b, 0)
            if (root.prevCpu.total > 0) {
                const dt = total - root.prevCpu.total
                const di = idle - root.prevCpu.idle
                if (dt > 0)
                    root.cpuUsage = Math.max(0, Math.min(100, 100 * (1 - di / dt)))
            }
            root.prevCpu = { total: total, idle: idle }
        }
    }

    FileView {
        id: memFile
        path: "/proc/meminfo"
        onLoaded: {
            const t = memFile.text()
            const total = /MemTotal:\s+(\d+)/.exec(t)
            const avail = /MemAvailable:\s+(\d+)/.exec(t)
            if (total && avail)
                root.memUsage = 100 * (1 - Number(avail[1]) / Number(total[1]))
        }
    }

    Process {
        id: gpuProc
        command: ["python3", "/home/malkkxd/.config/quickshell/gpu-usage"]
        stdout: StdioCollector {
            onStreamFinished: {
                const v = parseInt(this.text.trim())
                if (!isNaN(v))
                    root.gpuUsage = v
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: if (!gpuProc.running)
            gpuProc.running = true
    }

    FileView {
        id: batCap
        path: "/sys/class/power_supply/BAT0/capacity"
        onLoaded: root.batteryLevel = Number(batCap.text().trim())
    }

    FileView {
        id: batStat
        path: "/sys/class/power_supply/BAT0/status"
        onLoaded: root.charging = batStat.text().trim() === "Charging"
    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            statFile.reload()
            memFile.reload()
            batCap.reload()
            batStat.reload()
        }
    }

    // ------------------------------------------------------- volumen
    Process {
        id: volGetProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                const text = this.text.trim()
                const m = /Volume:\s+([0-9.]+)/.exec(text)
                if (m)
                    root.volumePercent = Math.round(Number(m[1]) * 100)
                root.volumeMuted = text.indexOf("[MUTED]") !== -1
            }
        }
    }

    Process {
        id: volUpProc
        command: ["wpctl", "set-volume", "-l", "1", "@DEFAULT_AUDIO_SINK@", "5%+"]
        onExited: if (!volGetProc.running) volGetProc.running = true
    }

    Process {
        id: volDownProc
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]
        onExited: if (!volGetProc.running) volGetProc.running = true
    }

    Process {
        id: volMuteProc
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        onExited: if (!volGetProc.running) volGetProc.running = true
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: if (!volGetProc.running)
            volGetProc.running = true
    }

    // -------------------------------------------- selector de audio
    function refreshAudio() {
        if (!audioSinksProc.running)
            audioSinksProc.running = true
        if (!audioSourcesProc.running)
            audioSourcesProc.running = true
        if (!audioDefaultsProc.running)
            audioDefaultsProc.running = true
    }

    function setAudioSink(name) {
        if (!name || name === "")
            return
        audioSetSinkProc.command = ["pactl", "set-default-sink", name]
        audioSetSinkProc.running = true
    }

    function setAudioSource(name) {
        if (!name || name === "")
            return
        audioSetSourceProc.command = ["pactl", "set-default-source", name]
        audioSetSourceProc.running = true
    }

    function audioLabel(dev) {
        if (!dev)
            return ""
        let d = String(dev.description || dev.name || "")
        d = d.replace(/^.*?\(HD Audio\)\s*/i, "")
        d = d.replace(/HDMI \/ DisplayPort (\d+) Output \(Stereo\)/i, "HDMI/DP $1")
        d = d.replace(/\s*Output \(Stereo\)/i, "")
        if (root.uiLanguage === "en") {
            d = d.replace(/Analog Stereo/i, "analog stereo")
            d = d.replace(/Headset Mono Microphone/i, "Headset mic")
            d = d.replace(/Digital Microphone/i, "Digital mic")
            d = d.replace(/^Speaker$/i, "Internal speakers")
            d = d.replace(/\s+/g, " ").trim()
            if (d.length > 44)
                d = d.slice(0, 43) + "…"
            return d
        }
        d = d.replace(/Estéreo analógico/i, root.t("audio.analogStereo"))
        d = d.replace(/Headset Mono Microphone/i, "Micrófono de auriculares")
        d = d.replace(/Digital Microphone/i, "Micrófono digital")
        d = d.replace(/^Speaker$/i, "Altavoces internos")
        d = d.replace(/USB Audio Device/i, "USB Audio")
        d = d.replace(/\s+/g, " ").trim()
        if (d.length > 44)
            d = d.slice(0, 43) + "…"
        return d
    }

    function audioIcon(dev, isSink) {
        const d = String((dev && (dev.description || dev.name)) || "").toLowerCase()
        if (isSink) {
            if (d.indexOf("headphone") !== -1 || d.indexOf("headset") !== -1)
                return "\uf025"
            if (d.indexOf("hdmi") !== -1 || d.indexOf("displayport") !== -1)
                return "\uf108"
            if (d.indexOf("usb") !== -1)
                return "\uf287"
            return "\uf028"
        }
        if (d.indexOf("usb") !== -1)
            return "\uf287"
        return "\uf130"
    }

    function audioDefaultLabel(isSink) {
        const list = isSink ? root.audioSinks : root.audioSources
        const name = isSink ? root.audioDefaultSink : root.audioDefaultSource
        for (let i = 0; i < list.length; i++) {
            if (list[i].name === name)
                return root.audioLabel(list[i])
        }
        return name || (isSink ? root.t("audio.noOutput") : root.t("audio.noInput"))
    }

    Process {
        id: audioSinksProc
        command: ["pactl", "-f", "json", "list", "sinks"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const list = JSON.parse(this.text)
                    if (Array.isArray(list))
                        root.audioSinks = list
                } catch (e) {
                    console.warn("audio sinks:", e)
                }
            }
        }
    }

    Process {
        id: audioSourcesProc
        command: ["pactl", "-f", "json", "list", "sources"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const list = JSON.parse(this.text)
                    if (Array.isArray(list))
                        root.audioSources = list.filter(s => !String(s.name || "").endsWith(".monitor"))
                } catch (e) {
                    console.warn("audio sources:", e)
                }
            }
        }
    }

    Process {
        id: audioDefaultsProc
        command: ["bash", "-c", "pactl get-default-sink; pactl get-default-source"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.split("\n")
                root.audioDefaultSink = (lines[0] || "").trim()
                root.audioDefaultSource = (lines[1] || "").trim()
            }
        }
    }

    Process {
        id: audioSetSinkProc
        command: ["pactl", "set-default-sink", ""]
        onExited: {
            root.refreshAudio()
            if (!volGetProc.running)
                volGetProc.running = true
        }
    }

    Process {
        id: audioSetSourceProc
        command: ["pactl", "set-default-source", ""]
        onExited: root.refreshAudio()
    }

    Component.onCompleted: root.refreshAudio()

    // ------------------------------------------------------- bluetooth
    property string btPairingAddress: ""

    Process {
        id: btPairProc
        property string target: ""
        command: ["bluetoothctl", "--agent", "NoInputNoOutput", "--timeout", "45", "pair", target]
        onExited: {
            if (root.btPairingAddress === target)
                root.btPairingAddress = ""
            target = ""
        }
    }

    // ------------------------------------------------------- fullscreen
    Process {
        id: clientsProc
        command: ["hyprctl", "-j", "clients"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const list = JSON.parse(this.text)
                    const mons = Hyprland.monitors.values
                    const fs = {}
                    for (const c of list) {
                        if (c.fullscreen < 2)
                            continue
                        const mon = mons.find(m => m.id === c.monitor)
                        if (!mon)
                            continue
                        const wsId = mon.activeWorkspace ? mon.activeWorkspace.id : -1
                        if (c.workspace.id === wsId)
                            fs[mon.name] = true
                    }
                    root.fullscreenMonitors = fs
                } catch (e) {
                }
            }
        }
    }

    Timer {
        interval: 700
        running: true
        repeat: true
        onTriggered: if (!clientsProc.running)
            clientsProc.running = true
    }

    // ------------------------------------------------------------ cava
    Process {
        id: cavaProc
        command: ["cava", "-p", "/home/malkkxd/.config/hypr/cava.conf"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                const parts = line.split(";").filter(p => p.length > 0).map(Number)
                if (parts.length > 0)
                    root.cavaValues = parts
            }
        }
        onExited: cavaRetry.start()
    }

    Timer {
        id: cavaRetry
        interval: 2500
        onTriggered: cavaProc.running = true
    }

    // --------------------------------------------------------- apagado
    Process {
        id: wlogoutProc
        command: ["bash", "-c", "wlogout --protocol layer-shell -l ~/.config/hypr/wlogout/layout -C ~/.config/hypr/wlogout/style.css -b 5"]
    }

    // ------------------------------------------ control center: widgets
    SystemClock {
        id: ccClock
        precision: SystemClock.Minutes
    }

    component CcSlider: Item {
        id: sliderRoot
        property string icon: ""
        property real value: 0
        property real maxValue: 100
        signal moved(real value)

        implicitHeight: 30

        Text {
            id: sliderIcon
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 18
            text: sliderRoot.icon
            color: root.alpha(root.theme.subtext, 0.95)
            font.family: root.mono
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: sliderPct
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 36
            text: Math.round(sliderRoot.value) + "%"
            color: root.theme.text
            font.family: root.mono
            font.pixelSize: 9
            horizontalAlignment: Text.AlignRight
        }

        Rectangle {
            id: sliderTouch
            anchors.left: sliderIcon.right
            anchors.leftMargin: 8
            anchors.right: sliderPct.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            height: 28
            color: "transparent"

            readonly property real ratio: Math.max(0, Math.min(1, sliderRoot.value / Math.max(1, sliderRoot.maxValue)))

            Rectangle {
                anchors.fill: parent
                anchors.topMargin: 9
                anchors.bottomMargin: 9
                radius: 5
                color: root.alpha(root.theme.surfaceHigh, 0.9)
            }

            Rectangle {
                height: 12
                radius: 6
                width: Math.max(10, sliderTouch.width * sliderTouch.ratio)
                anchors.verticalCenter: parent.verticalCenter
                color: root.alpha(root.theme.accent, 0.20)
            }

            Rectangle {
                height: 6
                radius: 3
                width: Math.max(6, sliderTouch.width * sliderTouch.ratio)
                anchors.verticalCenter: parent.verticalCenter
                color: root.theme.accent
            }

            Rectangle {
                id: sliderKnob
                width: 14
                height: 14
                radius: 7
                anchors.verticalCenter: parent.verticalCenter
                x: Math.max(0, Math.min(sliderTouch.width - sliderKnob.width,
                                        sliderTouch.width * sliderTouch.ratio - sliderKnob.width / 2))
                color: root.theme.accentSoft
                border.width: 2
                border.color: root.theme.accent
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeHorCursor

                function apply(x) {
                    const ratio = Math.max(0, Math.min(1, x / width))
                    sliderRoot.moved(ratio * sliderRoot.maxValue)
                }

                onPressed: mouse => apply(mouse.x)
                onPositionChanged: mouse => {
                    if (pressed)
                        apply(mouse.x)
                }
                onWheel: wheel => {
                    const next = sliderRoot.value + (wheel.angleDelta.y > 0 ? 5 : -5)
                    sliderRoot.moved(Math.max(0, Math.min(sliderRoot.maxValue, next)))
                }
            }
        }
    }

    component CcToggle: Rectangle {
        id: toggleRoot
        property string icon: ""
        property string label: ""
        property string sub: ""
        property bool active: false
        signal activated()

        implicitHeight: 50
        radius: 14
        color: toggleRoot.active ? root.alpha(root.theme.accent, 0.16)
                                 : root.alpha(root.theme.surface, 0.65)
        border.width: 1
        border.color: toggleRoot.active ? root.alpha(root.theme.accent, 0.55)
                                        : root.alpha(root.theme.outline, 0.14)

        Behavior on color {
            ColorAnimation { duration: 130 }
        }

        Rectangle {
            id: toggleIconBg
            x: 9
            anchors.verticalCenter: parent.verticalCenter
            width: 26
            height: 26
            radius: 9
            color: toggleRoot.active ? root.alpha(root.theme.accent, 0.22)
                                     : root.alpha(root.theme.surfaceHigh, 0.85)

            Text {
                anchors.centerIn: parent
                text: toggleRoot.icon
                color: toggleRoot.active ? root.theme.accent
                                         : root.alpha(root.theme.subtext, 0.9)
                font.family: root.mono
                font.pixelSize: 12
            }
        }

        Text {
            id: toggleLabel
            anchors.left: toggleIconBg.right
            anchors.leftMargin: 7
            anchors.right: parent.right
            anchors.rightMargin: 6
            anchors.top: parent.top
            anchors.topMargin: 9
            text: toggleRoot.label
            color: toggleRoot.active ? root.theme.text : root.alpha(root.theme.text, 0.92)
            font.family: root.mono
            font.pixelSize: 8
            font.bold: true
            elide: Text.ElideRight
        }

        Text {
            anchors.left: toggleLabel.left
            anchors.right: toggleLabel.right
            anchors.top: toggleLabel.bottom
            anchors.topMargin: 2
            text: toggleRoot.sub
            color: toggleRoot.active ? root.alpha(root.theme.accentSoft, 0.9)
                                     : root.alpha(root.theme.subtext, 0.62)
            font.family: root.mono
            font.pixelSize: 7
            elide: Text.ElideRight
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: toggleRoot.activated()
        }
    }

    // -------------------------------------------------- control center ui
    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: ccWindow
            required property var modelData

            screen: modelData
            visible: root.ccVisible

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore

            WlrLayershell.namespace: "quickshell-cc"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: (root.ccOpen && root.ccMonitor === modelData.name)
                                         ? WlrKeyboardFocus.Exclusive
                                         : WlrKeyboardFocus.None

            Rectangle {
                anchors.fill: parent
                anchors.margins: -100
                color: root.alpha("#000000", 0.34)
                opacity: (root.ccOpen && root.ccEntered) ? 1 : 0

                Behavior on opacity {
                    NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: root.ccOpen = false
                }
            }

            Rectangle {
                id: ccCard
                visible: root.ccMonitor === modelData.name
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 46
                anchors.rightMargin: 10
                width: 352
                height: Math.min(ccColumn.implicitHeight + 32, parent.height - 66)
                radius: 20
                border.width: 1
                border.color: root.alpha(root.theme.accent, 0.35)
                opacity: (root.ccOpen && root.ccEntered) ? 1 : 0

                gradient: Gradient {
                    GradientStop { position: 0.0; color: root.theme.surface }
                    GradientStop { position: 1.0; color: root.theme.bg }
                }

                transform: Scale {
                    origin.x: ccCard.width
                    origin.y: 0
                    xScale: (root.ccOpen && root.ccEntered) ? 1 : 0.96
                    yScale: (root.ccOpen && root.ccEntered) ? 1 : 0.96

                    Behavior on xScale {
                        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                    }
                    Behavior on yScale {
                        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                    }
                }

                Behavior on opacity {
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }

                Rectangle {
                    anchors.top: parent.top
                    anchors.topMargin: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 90
                    height: 2
                    radius: 1
                    opacity: 0.75
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "transparent" }
                        GradientStop { position: 0.5; color: root.theme.accent }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.AllButtons
                    onWheel: wheel => wheel.accepted = true
                }

                FocusScope {
                    anchors.fill: parent
                    focus: root.ccOpen
                    Keys.onEscapePressed: root.ccOpen = false

                    Flickable {
                        id: ccFlick
                        anchors.fill: parent
                        anchors.margins: 16
                        contentWidth: width
                        contentHeight: ccColumn.implicitHeight
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds

                        Connections {
                            target: root

                            function onCcOpenChanged() {
                                if (root.ccOpen)
                                    ccFlick.contentY = 0
                            }
                        }

                        Column {
                            id: ccColumn
                            width: ccFlick.width
                            spacing: 12

                            // ------------------------------------------ cabecera
                            Item {
                                width: parent.width
                                height: 44

                                Column {
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 1

                                    Text {
                                        text: Qt.formatDateTime(ccClock.date, "HH:mm")
                                        color: root.theme.text
                                        font.family: root.mono
                                        font.pixelSize: 27
                                        font.bold: true
                                    }

                                    Text {
                                        text: root.dayLabel(ccClock.date)
                                        color: root.alpha(root.theme.subtext, 0.75)
                                        font.family: root.mono
                                        font.pixelSize: 8
                                    }
                                }

                                Rectangle {
                                    id: closeBtn
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    width: 20
                                    height: 20
                                    radius: 10
                                    color: closeHover.hovered ? root.alpha(root.theme.accent, 0.22)
                                                              : root.alpha(root.theme.surfaceHigh, 0.6)

                                    Text {
                                        anchors.centerIn: parent
                                        text: "\uf00d"
                                        color: closeHover.hovered ? root.theme.accent
                                                                  : root.alpha(root.theme.subtext, 0.85)
                                        font.family: root.mono
                                        font.pixelSize: 9
                                    }

                                    HoverHandler {
                                        id: closeHover
                                        cursorShape: Qt.PointingHandCursor
                                    }

                                    TapHandler {
                                        onTapped: root.ccOpen = false
                                    }
                                }

                                Rectangle {
                                    id: batteryPill
                                    anchors.right: closeBtn.left
                                    anchors.rightMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: batteryRow.implicitWidth + 18
                                    height: 24
                                    radius: 12
                                    color: root.alpha(root.theme.surfaceHigh, 0.55)
                                    border.width: 1
                                    border.color: root.alpha(root.theme.accent, 0.20)

                                    Row {
                                        id: batteryRow
                                        anchors.centerIn: parent
                                        spacing: 5

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: root.batteryIcon()
                                            color: root.batteryLevel <= 15 ? root.theme.red
                                                                           : root.theme.accent
                                            font.family: root.mono
                                            font.pixelSize: 11
                                        }

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: root.batteryLevel + "%"
                                            color: root.theme.text
                                            font.family: root.mono
                                            font.pixelSize: 9
                                            font.bold: true
                                        }

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            visible: root.charging
                                            text: "\uf0e7"
                                            color: root.theme.yellow
                                            font.family: root.mono
                                            font.pixelSize: 8
                                        }
                                    }
                                }
                            }

                            // ------------------------------------------ media
                            Rectangle {
                                id: mediaCard
                                width: parent.width
                                height: 82
                                radius: 14
                                color: root.alpha(root.theme.surface, 0.70)
                                border.width: 1
                                border.color: root.alpha(root.theme.accent, 0.16)
                                clip: true

                                Rectangle {
                                    anchors.fill: parent
                                    radius: 14
                                    clip: true
                                    opacity: 0.16
                                    visible: root.mediaArt !== ""

                                    Image {
                                        anchors.fill: parent
                                        source: root.mediaArt
                                        fillMode: Image.PreserveAspectCrop
                                        asynchronous: true
                                        smooth: true
                                    }
                                }

                                Rectangle {
                                    id: mediaArtBox
                                    anchors.left: parent.left
                                    anchors.leftMargin: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 58
                                    height: 58
                                    radius: 10
                                    clip: true
                                    color: root.alpha(root.theme.surfaceHigh, 0.9)
                                    border.width: 1
                                    border.color: root.alpha(root.theme.accent, 0.22)

                                    Image {
                                        anchors.fill: parent
                                        visible: root.mediaArt !== ""
                                        source: root.mediaArt
                                        fillMode: Image.PreserveAspectCrop
                                        asynchronous: true
                                        smooth: true
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        visible: root.mediaArt === ""
                                        text: "\uf001"
                                        color: root.alpha(root.theme.accent, 0.75)
                                        font.family: root.mono
                                        font.pixelSize: 20
                                    }
                                }

                                Column {
                                    anchors.left: mediaArtBox.right
                                    anchors.leftMargin: 10
                                    anchors.right: mediaControls.left
                                    anchors.rightMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 3

                                    Text {
                                        width: parent.width
                                        text: root.mediaPlayer && root.mediaPlayer.trackTitle
                                              ? root.mediaPlayer.trackTitle
                                              : root.t("media.none")
                                        color: root.mediaPlayer ? root.theme.text
                                                                : root.alpha(root.theme.subtext, 0.8)
                                        font.family: root.mono
                                        font.pixelSize: 9
                                        font.bold: true
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        width: parent.width
                                        text: {
                                            const p = root.mediaPlayer
                                            if (!p)
                                                return root.t("media.hint")
                                            return p.trackArtist || p.identity || ""
                                        }
                                        color: root.alpha(root.theme.subtext, 0.75)
                                        font.family: root.mono
                                        font.pixelSize: 8
                                        elide: Text.ElideRight
                                    }

                                    Item {
                                        width: parent.width
                                        height: 4
                                        visible: root.mediaPlayer !== null

                                        Rectangle {
                                            anchors.fill: parent
                                            radius: 2
                                            color: root.alpha(root.theme.surfaceHigh, 0.95)
                                        }

                                        Rectangle {
                                            height: parent.height
                                            radius: 2
                                            width: parent.width * root.mediaProgress
                                            color: root.theme.accent
                                        }
                                    }

                                    Item {
                                        width: parent.width
                                        height: 10
                                        visible: root.mediaPlayer !== null

                                        Text {
                                            anchors.left: parent.left
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: root.mediaPlayer ? root.fmtTime(root.mediaPlayer.position) : "0:00"
                                            color: root.alpha(root.theme.subtext, 0.65)
                                            font.family: root.mono
                                            font.pixelSize: 7
                                        }

                                        Text {
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: root.mediaPlayer ? root.fmtTime(root.mediaPlayer.length) : "0:00"
                                            color: root.alpha(root.theme.subtext, 0.65)
                                            font.family: root.mono
                                            font.pixelSize: 7
                                        }
                                    }
                                }

                                Row {
                                    id: mediaControls
                                    anchors.right: parent.right
                                    anchors.rightMargin: 10
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 5
                                    visible: root.mediaPlayer !== null

                                    Rectangle {
                                        width: 20
                                        height: 20
                                        radius: 10
                                        opacity: root.mediaPlayer && !root.mediaPlayer.canGoPrevious ? 0.3 : 1
                                        color: prevHover.hovered ? root.alpha(root.theme.accent, 0.16)
                                                                 : "transparent"

                                        Text {
                                            anchors.centerIn: parent
                                            text: "\uf048"
                                            color: root.alpha(root.theme.subtext, 0.9)
                                            font.family: root.mono
                                            font.pixelSize: 9
                                        }

                                        HoverHandler {
                                            id: prevHover
                                            cursorShape: Qt.PointingHandCursor
                                        }

                                        TapHandler {
                                            onTapped: if (root.mediaPlayer)
                                                           root.mediaPlayer.previous()
                                        }
                                    }

                                    Rectangle {
                                        width: 28
                                        height: 28
                                        radius: 14
                                        color: playHover.hovered ? root.alpha(root.theme.accentSoft, 0.95)
                                                                 : root.theme.accent

                                        Text {
                                            anchors.centerIn: parent
                                            text: root.mediaPlayer && root.mediaPlayer.isPlaying
                                                  ? "\uf04c" : "\uf04b"
                                            color: root.theme.bg
                                            font.family: root.mono
                                            font.pixelSize: 10
                                        }

                                        HoverHandler {
                                            id: playHover
                                            cursorShape: Qt.PointingHandCursor
                                        }

                                        TapHandler {
                                            onTapped: if (root.mediaPlayer)
                                                           root.mediaPlayer.togglePlaying()
                                        }
                                    }

                                    Rectangle {
                                        width: 20
                                        height: 20
                                        radius: 10
                                        opacity: root.mediaPlayer && !root.mediaPlayer.canGoNext ? 0.3 : 1
                                        color: nextHover.hovered ? root.alpha(root.theme.accent, 0.16)
                                                                 : "transparent"

                                        Text {
                                            anchors.centerIn: parent
                                            text: "\uf051"
                                            color: root.alpha(root.theme.subtext, 0.9)
                                            font.family: root.mono
                                            font.pixelSize: 9
                                        }

                                        HoverHandler {
                                            id: nextHover
                                            cursorShape: Qt.PointingHandCursor
                                        }

                                        TapHandler {
                                            onTapped: if (root.mediaPlayer)
                                                           root.mediaPlayer.next()
                                        }
                                    }
                                }
                            }

                            // ------------------------------------------ sliders
                            CcSlider {
                                width: parent.width
                                icon: root.volumeMuted ? "\uf026"
                                                       : (root.volumePercent > 60 ? "\uf028" : "\uf027")
                                value: root.volumePercent
                                onMoved: value => root.setVolume(value)
                            }

                            CcSlider {
                                width: parent.width
                                icon: "\uf185"
                                value: root.brightness
                                onMoved: value => root.setBrightness(value)
                            }

                            // ------------------------------------------ toggles
                            Grid {
                                width: parent.width
                                columns: 3
                                spacing: 8

                                CcToggle {
                                    width: (parent.width - 16) / 3
                                    icon: "\uf1eb"
                                    label: root.t("toggles.wifi")
                                    sub: root.wifiOn ? (root.wifiSsid !== "" ? root.wifiSsid : root.t("toggles.on"))
                                                     : root.t("toggles.off")
                                    active: root.wifiOn
                                    onActivated: root.runToggle("wifi")
                                }

                                CcToggle {
                                    width: (parent.width - 16) / 3
                                    icon: "\uf293"
                                    label: root.t("toggles.bt")
                                    sub: root.btAdapterCC && root.btAdapterCC.enabled
                                         ? (root.btConnectedCC
                                            ? (root.btConnectedCC.name || root.t("status.connected"))
                                              + (root.btConnectedCC.batteryAvailable
                                                 ? " · " + Math.round(root.btConnectedCC.battery * 100) + "%"
                                                 : "")
                                            : root.t("toggles.on"))
                                         : root.t("toggles.off")
                                    active: root.toggleActive("bt")
                                    onActivated: root.runToggle("bt")
                                }

                                CcToggle {
                                    width: (parent.width - 16) / 3
                                    icon: "\uf0f3"
                                    label: root.t("toggles.dnd")
                                    sub: root.dnd ? root.t("toggles.muted") : root.t("toggles.normal")
                                    active: root.dnd
                                    onActivated: root.runToggle("dnd")
                                }

                                CcToggle {
                                    width: (parent.width - 16) / 3
                                    icon: "\uf0f4"
                                    label: root.t("toggles.awake")
                                    sub: root.keepAwake ? root.t("toggles.active") : root.t("toggles.off")
                                    active: root.keepAwake
                                    onActivated: root.runToggle("awake")
                                }

                                CcToggle {
                                    width: (parent.width - 16) / 3
                                    icon: "\uf023"
                                    label: root.t("toggles.lock")
                                    sub: root.t("toggles.screen")
                                    active: false
                                    onActivated: root.runToggle("lock")
                                }

                                CcToggle {
                                    width: (parent.width - 16) / 3
                                    icon: "\uf030"
                                    label: root.t("toggles.shot")
                                    sub: root.t("toggles.region")
                                    active: false
                                    onActivated: root.runToggle("shot")
                                }
                            }

                            // ------------------------------------------ acento
                            Column {
                                width: parent.width
                                spacing: 8

                                Item {
                                    width: parent.width
                                    height: 16

                                    Text {
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: root.t("accent.title")
                                        color: root.theme.text
                                        font.family: root.mono
                                        font.pixelSize: 9
                                        font.bold: true
                                    }

                                    Text {
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: root.accentMode === "auto" ? root.t("accent.auto")
                                                                         : root.t("accent.manual")
                                        color: root.alpha(root.theme.subtext, 0.7)
                                        font.family: root.mono
                                        font.pixelSize: 8
                                    }
                                }

                                Row {
                                    width: parent.width
                                    spacing: 7

                                    Repeater {
                                        model: root.accentPresets

                                        delegate: Rectangle {
                                            required property string modelData

                                            readonly property bool selected: root.accentMode === "manual"
                                                                            && root.theme.accent.toLowerCase() === modelData.toLowerCase()

                                            width: 28
                                            height: 28
                                            radius: 14
                                            color: modelData
                                            border.width: selected ? 2 : 1
                                            border.color: selected ? root.theme.text
                                                                   : root.alpha(root.theme.outline, 0.4)

                                            Text {
                                                anchors.centerIn: parent
                                                visible: parent.selected
                                                text: "\uf00c"
                                                color: root.theme.bg
                                                font.family: root.mono
                                                font.pixelSize: 9
                                                font.bold: true
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: root.setAccent(modelData)
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    width: parent.width
                                    height: 32
                                    radius: 10
                                    color: root.accentMode === "auto"
                                           ? root.alpha(root.accentAutoColor !== "" ? root.accentAutoColor
                                                                                   : root.theme.accent, 0.16)
                                           : root.alpha(root.theme.surface, 0.6)
                                    border.width: 1
                                    border.color: root.accentMode === "auto"
                                                  ? root.alpha(root.accentAutoColor !== "" ? root.accentAutoColor
                                                                                          : root.theme.accent, 0.5)
                                                  : root.alpha(root.theme.outline, 0.14)

                                    Row {
                                        anchors.centerIn: parent
                                        spacing: 8

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: "\uf043"
                                            color: root.accentMode === "auto" ? root.theme.accent
                                                                              : root.alpha(root.theme.subtext, 0.8)
                                            font.family: root.mono
                                            font.pixelSize: 9
                                        }

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: root.t("accent.autoHint")
                                            color: root.accentMode === "auto" ? root.theme.text
                                                                              : root.alpha(root.theme.text, 0.85)
                                            font.family: root.mono
                                            font.pixelSize: 8
                                        }

                                        Rectangle {
                                            anchors.verticalCenter: parent.verticalCenter
                                            visible: root.accentAutoColor !== ""
                                            width: 11
                                            height: 11
                                            radius: 6
                                            color: root.accentAutoColor
                                            border.width: 1
                                            border.color: root.alpha(root.theme.text, 0.5)
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.useAutoAccent()
                                    }
                                }
                            }

                            // ------------------------------------------ fondo
                            Column {
                                width: parent.width
                                spacing: 8

                                Item {
                                    width: parent.width
                                    height: 16

                                    Text {
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: root.t("wallpaper.title")
                                        color: root.theme.text
                                        font.family: root.mono
                                        font.pixelSize: 9
                                        font.bold: true
                                    }

                                    Text {
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: {
                                            const p = root.wallpaperFor(root.ccMonitor)
                                            return p ? p.split("/").pop() : ""
                                        }
                                        color: root.alpha(root.theme.subtext, 0.7)
                                        font.family: root.mono
                                        font.pixelSize: 8
                                        elide: Text.ElideMiddle
                                        width: parent.width * 0.55
                                        horizontalAlignment: Text.AlignRight
                                    }
                                }

                                Rectangle {
                                    width: parent.width
                                    height: 34
                                    radius: 10
                                    color: root.alpha(root.theme.surface, 0.6)
                                    border.width: 1
                                    border.color: root.alpha(root.theme.outline, 0.14)

                                    Row {
                                        anchors.centerIn: parent
                                        spacing: 8

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: "\uf03e"
                                            color: root.theme.accent
                                            font.family: root.mono
                                            font.pixelSize: 10
                                        }

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: root.t("wallpaper.change")
                                            color: root.theme.text
                                            font.family: root.mono
                                            font.pixelSize: 8
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.openWallpapers(root.ccMonitor)
                                    }
                                }
                            }

                            // ------------------------------------------ idioma
                            Column {
                                width: parent.width
                                spacing: 8

                                Item {
                                    width: parent.width
                                    height: 16

                                    Text {
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: root.t("lang.kbTitle")
                                        color: root.theme.text
                                        font.family: root.mono
                                        font.pixelSize: 9
                                        font.bold: true
                                    }

                                    Text {
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: root.keyboardLayoutIndex === 1
                                              ? root.t("lang.spanish")
                                              : root.t("lang.english")
                                        color: root.alpha(root.theme.subtext, 0.7)
                                        font.family: root.mono
                                        font.pixelSize: 8
                                    }
                                }

                                Row {
                                    width: parent.width
                                    spacing: 8

                                    Repeater {
                                        model: [
                                            { label: "English", code: "us" },
                                            { label: "Español", code: "latam" }
                                        ]

                                        delegate: Rectangle {
                                            required property var modelData
                                            required property int index

                                            readonly property bool selected: root.keyboardLayoutIndex === index

                                            width: (parent.width - 8) / 2
                                            height: 30
                                            radius: 9
                                            color: selected ? root.alpha(root.theme.accent, 0.16)
                                                            : root.alpha(root.theme.surface, 0.6)
                                            border.width: 1
                                            border.color: selected ? root.alpha(root.theme.accent, 0.55)
                                                                   : root.alpha(root.theme.outline, 0.14)

                                            Text {
                                                anchors.centerIn: parent
                                                text: modelData.label
                                                color: parent.selected ? root.theme.accent
                                                                       : root.alpha(root.theme.text, 0.85)
                                                font.family: root.mono
                                                font.pixelSize: 9
                                                font.bold: parent.selected
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: root.setKeyboardLayout(index)
                                            }
                                        }
                                    }
                                }
                            }

                            // ------------------------------------------ idioma ui
                            Column {
                                width: parent.width
                                spacing: 8

                                Item {
                                    width: parent.width
                                    height: 16

                                    Text {
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: root.t("lang.uiTitle")
                                        color: root.theme.text
                                        font.family: root.mono
                                        font.pixelSize: 9
                                        font.bold: true
                                    }

                                    Text {
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: root.uiLanguage === "en"
                                              ? root.t("lang.english")
                                              : root.t("lang.spanish")
                                        color: root.alpha(root.theme.subtext, 0.7)
                                        font.family: root.mono
                                        font.pixelSize: 8
                                    }
                                }

                                Row {
                                    width: parent.width
                                    spacing: 8

                                    Repeater {
                                        model: [
                                            { label: root.t("lang.english"), code: "en" },
                                            { label: root.t("lang.spanish"), code: "es" }
                                        ]

                                        delegate: Rectangle {
                                            required property var modelData
                                            required property int index

                                            readonly property bool selected: root.uiLanguage === modelData.code

                                            width: (parent.width - 8) / 2
                                            height: 30
                                            radius: 9
                                            color: selected ? root.alpha(root.theme.accent, 0.16)
                                                            : root.alpha(root.theme.surface, 0.6)
                                            border.width: 1
                                            border.color: selected ? root.alpha(root.theme.accent, 0.55)
                                                                   : root.alpha(root.theme.outline, 0.14)

                                            Text {
                                                anchors.centerIn: parent
                                                text: modelData.label
                                                color: parent.selected ? root.theme.accent
                                                                       : root.alpha(root.theme.text, 0.85)
                                                font.family: root.mono
                                                font.pixelSize: 9
                                                font.bold: parent.selected
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: root.setUiLanguage(modelData.code)
                                            }
                                        }
                                    }
                                }
                            }

                            // ------------------------------------------ calendario
                            Column {
                                width: parent.width
                                spacing: 6

                                Item {
                                    width: parent.width
                                    height: 24

                                    Text {
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: root.monthLabel(new Date(ccClock.date.getFullYear(),
                                                                       ccClock.date.getMonth() + root.ccMonthOffset, 1))
                                        color: root.theme.text
                                        font.family: root.mono
                                        font.pixelSize: 10
                                        font.bold: true
                                    }

                                    Rectangle {
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 22
                                        height: 22
                                        radius: 8
                                        color: nextMonthHover.hovered ? root.alpha(root.theme.accent, 0.16)
                                                                      : "transparent"

                                        Text {
                                            anchors.centerIn: parent
                                            text: "\uf054"
                                            color: root.alpha(root.theme.subtext, 0.85)
                                            font.family: root.mono
                                            font.pixelSize: 8
                                        }

                                        HoverHandler {
                                            id: nextMonthHover
                                            cursorShape: Qt.PointingHandCursor
                                        }

                                        TapHandler {
                                            onTapped: root.ccMonthOffset++
                                        }
                                    }

                                    Rectangle {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 26
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 22
                                        height: 22
                                        radius: 8
                                        color: prevMonthHover.hovered ? root.alpha(root.theme.accent, 0.16)
                                                                      : "transparent"

                                        Text {
                                            anchors.centerIn: parent
                                            text: "\uf053"
                                            color: root.alpha(root.theme.subtext, 0.85)
                                            font.family: root.mono
                                            font.pixelSize: 8
                                        }

                                        HoverHandler {
                                            id: prevMonthHover
                                            cursorShape: Qt.PointingHandCursor
                                        }

                                        TapHandler {
                                            onTapped: root.ccMonthOffset--
                                        }
                                    }

                                    Rectangle {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 54
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: resetMonthLabel.implicitWidth + 12
                                        height: 18
                                        radius: 9
                                        visible: root.ccMonthOffset !== 0
                                        color: resetMonthHover.hovered ? root.alpha(root.theme.accent, 0.16)
                                                                       : "transparent"

                                        Text {
                                            id: resetMonthLabel
                                            anchors.centerIn: parent
                                            text: root.t("cal.today")
                                            color: root.theme.accent
                                            font.family: root.mono
                                            font.pixelSize: 7
                                        }

                                        HoverHandler {
                                            id: resetMonthHover
                                            cursorShape: Qt.PointingHandCursor
                                        }

                                        TapHandler {
                                            onTapped: root.ccMonthOffset = 0
                                        }
                                    }
                                }

                                Row {
                                    width: parent.width
                                    spacing: 4

                                    Repeater {
                                        model: root.uiWeekdays

                                        delegate: Text {
                                            required property var modelData
                                            required property int index
                                            width: (ccColumn.width - 24) / 7
                                            text: modelData
                                            color: index >= 5 ? root.alpha(root.theme.accent, 0.55)
                                                              : root.alpha(root.theme.subtext, 0.55)
                                            font.family: root.mono
                                            font.pixelSize: 7
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                    }
                                }

                                Grid {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    columns: 7
                                    columnSpacing: 4
                                    rowSpacing: 2

                                    Repeater {
                                        model: root.monthCells(new Date(ccClock.date.getFullYear(),
                                                                        ccClock.date.getMonth() + root.ccMonthOffset, 1))

                                        delegate: Rectangle {
                                            required property var modelData
                                            width: (ccColumn.width - 24) / 7
                                            height: 26
                                            radius: 13
                                            color: {
                                                if (modelData === 0)
                                                    return "transparent"
                                                if (root.ccMonthOffset === 0 && modelData === ccClock.date.getDate())
                                                    return root.theme.accent
                                                return "transparent"
                                            }

                                            Text {
                                                anchors.centerIn: parent
                                                visible: modelData !== 0
                                                text: modelData === 0 ? "" : modelData
                                                color: root.ccMonthOffset === 0 && modelData === ccClock.date.getDate()
                                                       ? root.theme.bg
                                                       : root.alpha(root.theme.text, 0.85)
                                                font.family: root.mono
                                                font.pixelSize: 8
                                                font.bold: root.ccMonthOffset === 0 && modelData === ccClock.date.getDate()
                                            }
                                        }
                                    }
                                }
                            }

                            // ------------------------------------------ pie
                            Item {
                                width: parent.width
                                height: 18

                                Row {
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 10

                                    Row {
                                        spacing: 4

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: "\uf2db"
                                            color: root.alpha(root.theme.accent, 0.65)
                                            font.family: root.mono
                                            font.pixelSize: 8
                                        }

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: Math.round(root.cpuUsage) + "%"
                                            color: root.alpha(root.theme.subtext, 0.85)
                                            font.family: root.mono
                                            font.pixelSize: 8
                                        }
                                    }

                                    Row {
                                        spacing: 4

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: "\uf108"
                                            color: root.alpha(root.theme.accent, 0.65)
                                            font.family: root.mono
                                            font.pixelSize: 8
                                        }

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: root.gpuUsage + "%"
                                            color: root.alpha(root.theme.subtext, 0.85)
                                            font.family: root.mono
                                            font.pixelSize: 8
                                        }
                                    }

                                    Row {
                                        spacing: 4

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: "\uf035b"
                                            color: root.alpha(root.theme.accent, 0.65)
                                            font.family: root.mono
                                            font.pixelSize: 8
                                        }

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: Math.round(root.memUsage) + "%"
                                            color: root.alpha(root.theme.subtext, 0.85)
                                            font.family: root.mono
                                            font.pixelSize: 8
                                        }
                                    }
                                }

                            }
                        }
                    }

                    Rectangle {
                        visible: ccFlick.contentHeight > ccFlick.height + 1
                        anchors.right: parent.right
                        anchors.rightMargin: 5
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: 18
                        anchors.bottomMargin: 18
                        width: 3
                        radius: 1.5
                        color: root.alpha(root.theme.outline, 0.12)

                        Rectangle {
                            width: parent.width
                            height: Math.max(24, ccFlick.height * ccFlick.height
                                                 / Math.max(1, ccFlick.contentHeight))
                            y: (parent.height - height) * Math.max(0, Math.min(1,
                                   ccFlick.contentY / Math.max(1, ccFlick.contentHeight - ccFlick.height)))
                            radius: 1.5
                            color: root.alpha(root.theme.accent, 0.4)
                        }
                    }
                }
            }
        }
    }

    // -------------------------------------------------- selector de fondos ui
    Process {
        id: wpListProc
        command: ["/home/malkkxd/.config/quickshell/scripts/list-wallpapers.sh"]
        stdout: StdioCollector {
            onStreamFinished: root.wallpapers = root.parseWallpaperList(this.text)
        }
    }

    Process {
        id: wpApplyProc
        command: ["bash", "/home/malkkxd/.config/hypr/scripts/wallpaper.sh"]
    }

    Timer {
        id: wpEnterTimer
        interval: 40
        repeat: false
        onTriggered: root.wpEntered = true
    }

    Timer {
        id: wpCloseTimer
        interval: 240
        repeat: false
        onTriggered: root.wpVisible = false
    }

    Connections {
        target: root

        function onWpOpenChanged() {
            if (root.wpOpen)
                root.wpVisible = true
            else
                wpCloseTimer.restart()
        }
    }

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: wpWindow
            required property var modelData

            screen: modelData
            visible: root.wpVisible && root.wpMonitor === modelData.name

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore

            WlrLayershell.namespace: "quickshell-wallpapers"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: (root.wpOpen && root.wpMonitor === modelData.name)
                                         ? WlrKeyboardFocus.Exclusive
                                         : WlrKeyboardFocus.None

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: root.wpOpen = false
            }

            FocusScope {
                anchors.fill: parent
                focus: root.wpOpen
                Keys.onEscapePressed: root.wpOpen = false

                Item {
                    id: wpField
                    anchors.fill: parent
                    anchors.margins: 64
                    visible: root.wpMonitor === modelData.name
                    opacity: (root.wpOpen && root.wpEntered) ? 1 : 0
                    readonly property var hexLayout: root.hexLayoutFor(root.wallpapers.length, width, height)

                    Behavior on opacity {
                        NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                    }

                    Repeater {
                        model: root.wallpapers

                        delegate: Item {
                            id: hexCell
                            required property var modelData
                            required property int index

                            readonly property var cell: (wpField.hexLayout.items && wpField.hexLayout.items[index])
                                                       ? wpField.hexLayout.items[index]
                                                       : null
                            readonly property bool current: root.wallpaperFor(root.wpMonitor) === modelData.path

                            x: cell ? cell.x : 0
                            y: cell ? cell.y : 0
                            width: cell ? cell.w : 0
                            height: cell ? cell.h : 0
                            opacity: hexHover.hovered ? 1 : (current ? 1 : 0.78)
                            scale: hexHover.hovered ? 1.05 : 1

                            Behavior on opacity {
                                NumberAnimation { duration: 130 }
                            }
                            Behavior on scale {
                                NumberAnimation { duration: 130; easing.type: Easing.OutCubic }
                            }

                            Image {
                                anchors.fill: parent
                                source: hexCell.modelData.thumb
                                fillMode: Image.PreserveAspectCrop
                                smooth: true
                                mipmap: true
                                asynchronous: true
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                y: parent.height * 0.55
                                visible: hexCell.current
                                text: "\uf00c"
                                color: root.theme.accent
                                style: Text.Outline
                                styleColor: "#000000"
                                font.family: root.mono
                                font.pixelSize: 15
                                font.bold: true
                            }

                            HoverHandler {
                                id: hexHover
                                cursorShape: Qt.PointingHandCursor
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: root.applyWallpaper(hexCell.modelData.path, root.wpMonitor)
                            }
                        }
                    }
                }
            }
        }
    }

    // -------------------------------------------------- control center
    property bool ccOpen: false
    property bool ccVisible: false
    property bool ccEntered: false
    property string ccMonitor: ""
    property int ccTick: 0
    property int brightness: 50
    property real pendingVolume: -1
    property real pendingBrightness: -1
    property bool wifiOn: false
    property string wifiSsid: ""
    property bool dnd: false
    property bool keepAwake: false
    property int ccMonthOffset: 0

    readonly property var btAdapterCC: Bluetooth.defaultAdapter
    readonly property var mediaPlayer: {
        const list = Mpris.players.values
        if (list.length === 0)
            return null
        return list.find(p => p.isPlaying) || list[0]
    }
    readonly property var btConnectedCC: {
        for (const d of Bluetooth.devices.values)
            if (d.connected)
                return d
        return null
    }
    readonly property real mediaProgress: {
        root.ccTick
        const p = root.mediaPlayer
        if (!p || !p.length || p.length <= 0)
            return 0
        return Math.max(0, Math.min(1, p.position / p.length))
    }
    readonly property string mediaArt: {
        const p = root.mediaPlayer
        if (!p || !p.trackArtUrl)
            return ""
        const u = p.trackArtUrl
        if (u.indexOf("://") !== -1)
            return u
        return "file://" + u
    }

    function fmtTime(seconds) {
        const s = Math.max(0, Math.floor(seconds || 0))
        return Math.floor(s / 60) + ":" + ("0" + (s % 60)).slice(-2)
    }

    readonly property var uiDayNames: root.uiLanguage === "en"
        ? ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        : ["domingo", "lunes", "martes", "miércoles", "jueves", "viernes", "sábado"]

    readonly property var uiMonthNames: root.uiLanguage === "en"
        ? ["January", "February", "March", "April", "May", "June",
           "July", "August", "September", "October", "November", "December"]
        : ["enero", "febrero", "marzo", "abril", "mayo", "junio",
           "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"]

    function dayLabel(date) {
        if (root.uiLanguage === "en")
            return root.uiDayNames[date.getDay()] + ", "
                   + root.uiMonthNames[date.getMonth()] + " " + date.getDate()
        return root.uiDayNames[date.getDay()] + " " + date.getDate() + " de "
               + root.uiMonthNames[date.getMonth()]
    }

    function openCC(monitorName) {
        root.wpOpen = false
        root.ccMonthOffset = 0
        root.ccMonitor = (monitorName && monitorName.length > 0)
                         ? monitorName
                         : (Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : "")
        root.ccEntered = false
        root.ccOpen = true
        root.ccVisible = true
        ccEnterTimer.restart()
    }

    function toggleCC(monitorName) {
        if (root.ccOpen)
            root.ccOpen = false
        else
            root.openCC(monitorName)
    }

    Connections {
        target: root

        function onCcOpenChanged() {
            if (root.ccOpen) {
                root.ccVisible = true
            } else {
                ccCloseTimer.restart()
            }
        }
    }

    Timer {
        id: ccCloseTimer
        interval: 260
        onTriggered: if (!root.ccOpen) {
            root.ccVisible = false
            root.ccEntered = false
        }
    }

    Timer {
        id: ccEnterTimer
        interval: 50
        onTriggered: root.ccEntered = true
    }


    function toggleActive(kind) {
        switch (kind) {
        case "wifi":
            return root.wifiOn
        case "bt":
            return root.btAdapterCC !== null && root.btAdapterCC.enabled
        case "dnd":
            return root.dnd
        case "awake":
            return root.keepAwake
        }
        return false
    }

    function runToggle(kind) {
        switch (kind) {
        case "wifi":
            wifiToggleProc.command = ["bash", "-c",
                "nmcli radio wifi " + (root.wifiOn ? "off" : "on")]
            wifiToggleProc.running = true
            break
        case "bt":
            if (root.btAdapterCC)
                root.btAdapterCC.enabled = !root.btAdapterCC.enabled
            break
        case "dnd":
            root.dnd = !root.dnd
            dndToggleProc.running = true
            break
        case "awake":
            root.keepAwake = !root.keepAwake
            break
        case "lock":
            root.ccOpen = false
            lockProc.running = true
            break
        case "shot":
            root.ccOpen = false
            root.ccVisible = false
            shotProc.running = true
            break
        }
    }

    function setVolume(percent) {
        root.volumePercent = Math.round(percent)
        root.pendingVolume = Math.round(percent)
    }

    function setBrightness(percent) {
        root.brightness = Math.round(percent)
        root.pendingBrightness = Math.round(percent)
    }

    function monthLabel(date) {
        return root.uiMonthNames[date.getMonth()] + " " + date.getFullYear()
    }

    function monthCells(date) {
        const first = new Date(date.getFullYear(), date.getMonth(), 1)
        const start = (first.getDay() + 6) % 7
        const days = new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate()
        const cells = []
        for (let i = 0; i < start; i++)
            cells.push(0)
        for (let d = 1; d <= days; d++)
            cells.push(d)
        while (cells.length % 7 !== 0)
            cells.push(0)
        return cells
    }

    Process {
        id: brightGetProc
        command: ["brightnessctl", "-m"]
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = this.text.trim().split(",")
                if (parts.length > 3) {
                    const v = parseInt(parts[3])
                    if (!isNaN(v))
                        root.brightness = v
                }
            }
        }
    }

    Process {
        id: brightSetProc
        command: ["brightnessctl", "set", "50%"]
    }

    Process {
        id: wifiGetProc
        command: ["nmcli", "radio", "wifi"]
        stdout: StdioCollector {
            onStreamFinished: root.wifiOn = this.text.trim() === "enabled"
        }
    }

    Process {
        id: wifiSsidProc
        command: ["bash", "-c",
                  "nmcli -t -f NAME,TYPE connection show --active 2>/dev/null | awk -F: '$2==\"802-11-wireless\" {print $1; exit}'"]
        stdout: StdioCollector {
            onStreamFinished: root.wifiSsid = this.text.trim()
        }
    }

    Process {
        id: wifiToggleProc
        command: ["bash", "-c", "nmcli radio wifi on"]
        onExited: {
            if (!wifiGetProc.running)
                wifiGetProc.running = true
        }
    }

    Process {
        id: dndGetProc
        command: ["dunstctl", "is-paused"]
        stdout: StdioCollector {
            onStreamFinished: root.dnd = this.text.trim() === "true"
        }
    }

    Process {
        id: dndToggleProc
        command: ["dunstctl", "set-paused", "toggle"]
        onExited: {
            if (!dndGetProc.running)
                dndGetProc.running = true
        }
    }

    Process {
        id: volSetProc
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "50%"]
    }

    Process {
        id: lockProc
        command: ["hyprlock"]
        onExited: root.ccOpen = false
    }

    Process {
        id: shotProc
        command: ["bash", "-c",
                  "mkdir -p \"$HOME/Imágenes/Capturas\" && hyprshot -m region -o \"$HOME/Imágenes/Capturas\""]
        onExited: root.ccOpen = false
    }

    Timer {
        interval: 110
        repeat: false
        running: root.pendingVolume >= 0
        onTriggered: {
            if (root.pendingVolume < 0)
                return
            volSetProc.command = ["bash", "-c",
                                  "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; "
                                  + "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ "
                                  + root.pendingVolume + "%"]
            volSetProc.running = true
            root.volumeMuted = false
            root.pendingVolume = -1
        }
    }

    Timer {
        interval: 110
        repeat: false
        running: root.pendingBrightness >= 0
        onTriggered: {
            if (root.pendingBrightness < 0)
                return
            brightSetProc.command = ["brightnessctl", "set", root.pendingBrightness + "%"]
            brightSetProc.running = true
            root.pendingBrightness = -1
        }
    }

    Timer {
        interval: 4000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!brightGetProc.running)
                brightGetProc.running = true
            if (!wifiGetProc.running)
                wifiGetProc.running = true
            if (!dndGetProc.running)
                dndGetProc.running = true
            if (root.wifiOn && !wifiSsidProc.running)
                wifiSsidProc.running = true
        }
    }

    Timer {
        interval: 1000
        running: root.ccOpen
        repeat: true
        triggeredOnStart: true
        onTriggered: root.ccTick++
    }

    IpcHandler {
        target: "cc"

        function toggle(): void {
            root.toggleCC("")
        }

        function open(): void {
            root.openCC("")
        }

        function close(): void {
            root.ccOpen = false
        }

        function layout(i: int): void {
            root.setKeyboardLayout(i)
        }

        function accent(hex: string): void {
            root.setAccent(hex)
        }

        function uilang(lang: string): void {
            root.setUiLanguage(lang)
        }

        function wallpaper(): void {
            if (root.wpOpen)
                root.wpOpen = false
            else
                root.openWallpapers("")
        }

        function wallclose(): void {
            root.wpOpen = false
        }

        function wallset(path: string): void {
            const mon = root.wpMonitor.length > 0
                        ? root.wpMonitor
                        : (Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : "")
            root.applyWallpaper(path, mon)
        }

        function wallrandom(): void {
            const mon = root.wpMonitor.length > 0
                        ? root.wpMonitor
                        : (Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : "")
            root.wpMonitor = mon
            if (root.wallpapers.length === 0) {
                if (!wpListProc.running)
                    wpListProc.running = true
                return
            }
            const pick = root.wallpapers[Math.floor(Math.random() * root.wallpapers.length)]
            root.applyWallpaper(pick.path, mon)
        }
    }

    // ------------------------------------------------------------ barra
    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: barWindow
            required property var modelData

            readonly property var wsBase: modelData.name === "HDMI-A-1"
                                              ? [6, 7, 8, 9, 10]
                                              : [1, 2, 3, 4, 5]
            readonly property var hyprMon: Hyprland.monitors.values.find(m => m.name === modelData.name)
            readonly property int activeWs: hyprMon && hyprMon.activeWorkspace
                                                ? hyprMon.activeWorkspace.id
                                                : -1
            readonly property var wsRange: {
                const base = wsBase.slice()
                const act = activeWs
                if (act > 0 && base.indexOf(act) === -1) {
                    base.push(act)
                    base.sort((a, b) => a - b)
                }
                return base
            }
            readonly property bool hiddenByFullscreen: root.fullscreenMonitors[modelData.name] === true

            readonly property var btAdapter: Bluetooth.defaultAdapter
            readonly property var btList: {
                const list = Bluetooth.devices.values.slice()
                list.sort((a, b) => {
                    if (a.connected !== b.connected)
                        return a.connected ? -1 : 1
                    if (a.paired !== b.paired)
                        return a.paired ? -1 : 1
                    return (a.name || a.address).localeCompare(b.name || b.address)
                })
                return list
            }
            readonly property bool btConnected: btList.some(d => d.connected)
            readonly property var btBatteryDevice: {
                for (const d of btList)
                    if (d.connected && d.batteryAvailable)
                        return d
                return null
            }
            property bool btOpen: false
            property bool audioOpen: false

            IdleInhibitor {
                enabled: root.keepAwake
                window: barWindow
            }

            readonly property var wsTasks: Hyprland.toplevels.values.filter(
                t => t.workspace && t.workspace.id === activeWs)
            readonly property var leftTasks: wsTasks.slice(0, Math.ceil(wsTasks.length / 2))
            readonly property var rightTasks: wsTasks.slice(Math.ceil(wsTasks.length / 2))

            screen: modelData
            visible: !hiddenByFullscreen

            anchors {
                top: true
                left: true
                right: true
            }
            margins {
                top: 4
                left: 8
                right: 8
            }
            implicitHeight: 34
            color: "transparent"

            WlrLayershell.namespace: "quickshell"
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            exclusionMode: ExclusionMode.Auto

            Item {
                id: barContent
                anchors.fill: parent

                // -------------------------------------- workspaces (izq.)
                Rectangle {
                    id: wsPill
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    height: 26
                    width: wsRow.implicitWidth + 14
                    radius: 13
                    color: root.alpha(root.theme.bg, 0.90)
                    border.width: 1
                    border.color: root.alpha(root.theme.accent, 0.22)

                    RowLayout {
                        id: wsRow
                        anchors.centerIn: parent
                        spacing: 4

                        Repeater {
                            model: barWindow.wsRange

                            delegate: Rectangle {
                                required property var modelData
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                                radius: 8

                                readonly property bool occupied: Hyprland.toplevels.values.some(
                                    t => t.workspace && t.workspace.id === modelData)
                                readonly property bool active: barWindow.activeWs === modelData

                                color: active ? root.theme.accent
                                              : (occupied ? root.alpha(root.theme.accent, 0.28)
                                                          : root.alpha(root.theme.surfaceHigh, 0.55))
                                border.width: active ? 0 : 1
                                border.color: occupied
                                                  ? root.alpha(root.theme.accent, 0.55)
                                                  : root.alpha(root.theme.outline, 0.22)

                                Behavior on color {
                                    ColorAnimation { duration: 120 }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + modelData + " })")
                                }
                            }
                        }
                    }
                }

                // --------------------------------------------- reloj (centro)
                Rectangle {
                    id: clockPill
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    height: 26
                    width: clockText.implicitWidth + 26
                    radius: 13
                    color: root.alpha(root.theme.bg, 0.90)
                    border.width: 1
                    border.color: root.alpha(root.theme.accent, 0.30)

                    SystemClock {
                        id: clock
                        precision: SystemClock.Seconds
                    }

                    Text {
                        id: clockText
                        anchors.centerIn: parent
                        text: Qt.formatDateTime(clock.date, "HH:mm:ss")
                        color: root.theme.text
                        font.family: root.mono
                        font.pixelSize: 12
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.toggleCC(barWindow.modelData.name)
                    }
                }

                // ------------------------- programas del workspace actual
                Row {
                    id: leftTasks
                    anchors.right: clockPill.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6
                    layoutDirection: Qt.RightToLeft
                    clip: true
                    width: Math.min(implicitWidth,
                                    Math.max(0, clockPill.x - wsPill.width - 30))

                    Repeater {
                        model: barWindow.leftTasks

                        delegate: Rectangle {
                            required property var modelData
                            height: 26
                            width: Math.min(taskLabel.implicitWidth + 34, 168)
                            radius: 13
                            color: root.alpha(root.theme.bg, 0.90)
                            border.width: 1
                            border.color: modelData.activated
                                          ? root.alpha(root.theme.accent, 0.55)
                                          : root.alpha(root.theme.accent, 0.18)

                            Image {
                                id: taskIcon
                                anchors.left: parent.left
                                anchors.leftMargin: 9
                                anchors.verticalCenter: parent.verticalCenter
                                width: 12
                                height: 12
                                visible: status === Image.Ready
                                source: Quickshell.iconPath(modelData.class || "", true)
                                smooth: true
                            }

                            Text {
                                id: taskLabel
                                anchors.left: taskIcon.visible ? taskIcon.right : parent.left
                                anchors.leftMargin: taskIcon.visible ? 6 : 9
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.title || modelData.class || ""
                                color: modelData.activated ? root.theme.text
                                                           : root.alpha(root.theme.subtext, 0.92)
                                font.family: root.mono
                                font.pixelSize: 9
                                elide: Text.ElideRight
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Hyprland.dispatch(
                                    'hl.dsp.focus({ window = "address:' + (modelData.address.indexOf("0x") === 0 ? modelData.address : "0x" + modelData.address) + '" })')
                            }
                        }
                    }
                }

                Row {
                    id: rightTasks
                    anchors.left: clockPill.right
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6
                    clip: true
                    width: Math.min(implicitWidth,
                                    Math.max(0, sysPill.x - (clockPill.x + clockPill.width) - 30))

                    Repeater {
                        model: barWindow.rightTasks

                        delegate: Rectangle {
                            required property var modelData
                            height: 26
                            width: Math.min(taskLabel2.implicitWidth + 34, 168)
                            radius: 13
                            color: root.alpha(root.theme.bg, 0.90)
                            border.width: 1
                            border.color: modelData.activated
                                          ? root.alpha(root.theme.accent, 0.55)
                                          : root.alpha(root.theme.accent, 0.18)

                            Image {
                                id: taskIcon2
                                anchors.left: parent.left
                                anchors.leftMargin: 9
                                anchors.verticalCenter: parent.verticalCenter
                                width: 12
                                height: 12
                                visible: status === Image.Ready
                                source: Quickshell.iconPath(modelData.class || "", true)
                                smooth: true
                            }

                            Text {
                                id: taskLabel2
                                anchors.left: taskIcon2.visible ? taskIcon2.right : parent.left
                                anchors.leftMargin: taskIcon2.visible ? 6 : 9
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.title || modelData.class || ""
                                color: modelData.activated ? root.theme.text
                                                           : root.alpha(root.theme.subtext, 0.92)
                                font.family: root.mono
                                font.pixelSize: 9
                                elide: Text.ElideRight
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Hyprland.dispatch(
                                    'hl.dsp.focus({ window = "address:' + (modelData.address.indexOf("0x") === 0 ? modelData.address : "0x" + modelData.address) + '" })')
                            }
                        }
                    }
                }

                // ------------------------------------------ sistema (der.)
                Rectangle {
                    id: sysPill
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: 26
                    width: sysRow.implicitWidth + 20
                    radius: 13
                    color: root.alpha(root.theme.bg, 0.90)
                    border.width: 1
                    border.color: root.alpha(root.theme.accent, 0.22)

                    RowLayout {
                        id: sysRow
                        anchors.centerIn: parent
                        spacing: 9

                        RowLayout {
                            spacing: 5

                            Repeater {
                                model: SystemTray.items.values

                                delegate: Image {
                                    required property var modelData
                                    Layout.preferredWidth: 12
                                    Layout.preferredHeight: 12
                                    source: modelData.icon && modelData.icon.startsWith("/")
                                                ? modelData.icon
                                                : Quickshell.iconPath(modelData.icon, true)
                                    smooth: true
                                }
                            }
                        }

                        Text {
                            id: powerBtn
                            Layout.alignment: Qt.AlignVCenter
                            text: "\uf011"
                            color: powerHover.hovered ? root.theme.accent
                                                      : root.alpha(root.theme.subtext, 0.9)
                            font.family: root.mono
                            font.pixelSize: 12

                            HoverHandler {
                                id: powerHover
                                cursorShape: Qt.PointingHandCursor
                            }

                            TapHandler {
                                onTapped: wlogoutProc.running = true
                            }
                        }

                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            text: "\uf2db " + Math.round(root.cpuUsage) + "%"
                            color: root.alpha(root.theme.subtext, 0.95)
                            font.family: root.mono
                            font.pixelSize: 10
                        }

                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            text: "\uf108 " + root.gpuUsage + "%"
                            color: root.alpha(root.theme.subtext, 0.95)
                            font.family: root.mono
                            font.pixelSize: 10
                        }

                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            text: "\uf035b " + Math.round(root.memUsage) + "%"
                            color: root.alpha(root.theme.subtext, 0.95)
                            font.family: root.mono
                            font.pixelSize: 10
                        }

                        RowLayout {
                            id: btButton
                            spacing: 3

                            Rectangle {
                                id: btHit
                                Layout.alignment: Qt.AlignVCenter
                                implicitWidth: 20
                                implicitHeight: 18
                                radius: 6
                                color: btHover.hovered
                                           ? root.alpha(root.theme.accent, 0.12)
                                           : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: "\uf293"
                                    color: !barWindow.btAdapter || !barWindow.btAdapter.enabled
                                               ? root.alpha(root.theme.red, 0.65)
                                               : (btHover.hovered
                                                      ? root.theme.accentSoft
                                                      : (barWindow.btConnected
                                                             ? root.theme.accent
                                                             : root.alpha(root.theme.subtext, 0.95)))
                                    font.family: root.mono
                                    font.pixelSize: 12
                                }

                                TapHandler {
                                    onTapped: {
                                        barWindow.audioOpen = false
                                        barWindow.btOpen = !barWindow.btOpen
                                    }
                                }

                                HoverHandler {
                                    id: btHover
                                    cursorShape: Qt.PointingHandCursor
                                }
                            }

                            Text {
                                Layout.alignment: Qt.AlignVCenter
                                visible: barWindow.btBatteryDevice !== null
                                text: barWindow.btBatteryDevice
                                          ? Math.round(barWindow.btBatteryDevice.battery * 100) + "%"
                                          : ""
                                color: root.alpha(root.theme.subtext, 0.9)
                                font.family: root.mono
                                font.pixelSize: 9
                            }
                        }

                        Text {
                            id: volText
                            Layout.alignment: Qt.AlignVCenter
                            text: (root.volumeMuted ? "\uf026 "
                                                    : (root.volumePercent > 60 ? "\uf028 " : "\uf027 "))
                                  + root.volumePercent + "%"
                            color: root.alpha(root.theme.subtext, 0.95)
                            font.family: root.mono
                            font.pixelSize: 10

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                onClicked: mouse => {
                                    if (mouse.button === Qt.RightButton) {
                                        volMuteProc.running = true
                                    } else {
                                        barWindow.btOpen = false
                                        barWindow.audioOpen = !barWindow.audioOpen
                                    }
                                }
                                onWheel: wheel => {
                                    if (wheel.angleDelta.y > 0)
                                        volUpProc.running = true
                                    else
                                        volDownProc.running = true
                                }
                            }
                        }

                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            text: root.batteryIcon() + " " + root.batteryLevel + "%"
                            color: root.batteryLevel <= 15 ? root.theme.red
                                                           : root.alpha(root.theme.subtext, 0.95)
                            font.family: root.mono
                            font.pixelSize: 10
                        }
                    }
                }
            }

            // Popup anclado al icono de Bluetooth: xdg_popup, no una ventana toplevel.
            PopupWindow {
                id: btPopup
                anchor.item: btHit
                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
                anchor.adjustment: PopupAdjustment.Slide | PopupAdjustment.Flip
                anchor.margins.bottom: -8

                visible: barWindow.btOpen && !barWindow.hiddenByFullscreen
                grabFocus: true
                implicitWidth: 344
                implicitHeight: btPopupColumn.implicitHeight + 24
                color: "transparent"

                onVisibleChanged: {
                    if (!visible) {
                        if (barWindow.btOpen)
                            barWindow.btOpen = false
                        if (barWindow.btAdapter)
                            barWindow.btAdapter.discovering = false
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 14
                    color: root.theme.bg
                    border.width: 1
                    border.color: root.alpha(root.theme.accent, 0.30)

                    Shortcut {
                        sequence: "Escape"
                        onActivated: barWindow.btOpen = false
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: 1
                        height: 2
                        radius: 1
                        color: root.alpha(root.theme.accent, 0.55)
                    }

                    ColumnLayout {
                        id: btPopupColumn
                        x: 12
                        y: 12
                        width: parent.width - 24
                        spacing: 8

                        // Cabecera: título, adaptador y switch
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Text {
                                Layout.alignment: Qt.AlignVCenter
                                text: "\uf293"
                                color: root.theme.accent
                                font.family: root.mono
                                font.pixelSize: 16
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0

                                Text {
                                    Layout.fillWidth: true
                                    text: root.t("bt.title")
                                    color: root.theme.text
                                    font.family: root.mono
                                    font.pixelSize: 12
                                    font.bold: true
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: barWindow.btAdapter
                                              ? (barWindow.btAdapter.enabled
                                                     ? (barWindow.btAdapter.name || root.t("status.adapter"))
                                                     : root.t("toggles.off"))
                                              : "Sin adaptador"
                                    color: root.alpha(root.theme.subtext, 0.85)
                                    font.family: root.mono
                                    font.pixelSize: 8
                                    elide: Text.ElideRight
                                }
                            }

                            Rectangle {
                                id: btSwitch
                                Layout.alignment: Qt.AlignVCenter
                                implicitWidth: 36
                                implicitHeight: 20
                                radius: 10
                                color: barWindow.btAdapter && barWindow.btAdapter.enabled
                                           ? root.alpha(root.theme.accent, 0.9)
                                           : root.alpha(root.theme.surfaceHigh, 0.9)
                                border.width: 1
                                border.color: root.alpha(root.theme.accent, 0.25)

                                Rectangle {
                                    width: 16
                                    height: 16
                                    radius: 8
                                    y: 2
                                    x: barWindow.btAdapter && barWindow.btAdapter.enabled
                                           ? btSwitch.width - width - 2
                                           : 2
                                    color: barWindow.btAdapter && barWindow.btAdapter.enabled
                                               ? root.theme.bg
                                               : root.alpha(root.theme.subtext, 0.8)

                                    Behavior on x {
                                        NumberAnimation { duration: 120 }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    enabled: barWindow.btAdapter !== null
                                    onClicked: barWindow.btAdapter.enabled = !barWindow.btAdapter.enabled
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 1
                            color: root.alpha(root.theme.accent, 0.12)
                        }

                        // Botón de escaneo
                        Rectangle {
                            id: btScan
                            Layout.fillWidth: true
                            Layout.preferredHeight: 26
                            radius: 8
                            color: btScanHover.hovered
                                       ? root.alpha(root.theme.accent, 0.16)
                                       : root.alpha(root.theme.surface, 0.85)
                            border.width: 1
                            border.color: root.alpha(root.theme.accent, 0.22)
                            opacity: barWindow.btAdapter && barWindow.btAdapter.enabled ? 1 : 0.45

                            Text {
                                anchors.centerIn: parent
                                text: barWindow.btAdapter && barWindow.btAdapter.discovering
                                          ? root.t("bt.stopScan")
                                          : root.t("bt.scan")
                                color: root.alpha(root.theme.accentSoft, 0.95)
                                font.family: root.mono
                                font.pixelSize: 9
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                enabled: barWindow.btAdapter && barWindow.btAdapter.enabled
                                onClicked: barWindow.btAdapter.discovering = !barWindow.btAdapter.discovering
                            }

                            HoverHandler {
                                id: btScanHover
                            }
                        }

                        // Lista de dispositivos
                        ListView {
                            id: btDeviceList
                            Layout.fillWidth: true
                            Layout.preferredHeight: Math.min(contentHeight, 264)
                            visible: barWindow.btList.length > 0
                            clip: true
                            spacing: 2
                            boundsBehavior: Flickable.StopAtBounds
                            model: barWindow.btList

                            delegate: Rectangle {
                                required property var modelData

                                width: ListView.view.width
                                height: 44
                                radius: 9
                                color: deviceHover.hovered
                                           ? root.alpha(root.theme.accent, 0.08)
                                           : "transparent"
                                border.width: modelData.connected ? 1 : 0
                                border.color: root.alpha(root.theme.accent, 0.28)

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 8
                                    anchors.rightMargin: 6
                                    spacing: 8

                                    Text {
                                        Layout.alignment: Qt.AlignVCenter
                                        text: root.btIconFor(modelData)
                                        color: modelData.connected
                                                   ? root.theme.accent
                                                   : root.alpha(root.theme.subtext, 0.9)
                                        font.family: root.mono
                                        font.pixelSize: 14
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0

                                        Text {
                                            Layout.fillWidth: true
                                            text: modelData.name || modelData.address
                                            color: root.theme.text
                                            font.family: root.mono
                                            font.pixelSize: 10
                                            elide: Text.ElideRight
                                        }

                                        RowLayout {
                                            spacing: 4

                                            Text {
                                                text: root.btStatusFor(modelData)
                                                color: modelData.connected
                                                           ? root.alpha(root.theme.accentSoft, 0.9)
                                                           : root.alpha(root.theme.subtext, 0.75)
                                                font.family: root.mono
                                                font.pixelSize: 8
                                            }

                                            Text {
                                                visible: modelData.batteryAvailable
                                                text: "· " + Math.round(modelData.battery * 100) + "%"
                                                color: root.alpha(root.theme.subtext, 0.75)
                                                font.family: root.mono
                                                font.pixelSize: 8
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.alignment: Qt.AlignVCenter
                                        Layout.preferredWidth: modelData.connected ? 78 : 74
                                        Layout.preferredHeight: 22
                                        radius: 7
                                        opacity: barWindow.btAdapter && barWindow.btAdapter.enabled ? 1 : 0.45
                                        color: modelData.connected
                                                   ? root.alpha(root.theme.surfaceHigh, 0.9)
                                                   : root.alpha(root.theme.accent, 0.16)
                                        border.width: 1
                                        border.color: root.alpha(root.theme.accent,
                                                                 modelData.connected ? 0.18 : 0.35)

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.connected
                                                      ? root.t("bt.disconnect")
                                                      : (modelData.pairing
                                                             || root.btPairingAddress === modelData.address
                                                             ? root.t("bt.cancel")
                                                             : (modelData.state === BluetoothDeviceState.Connecting
                                                                    ? root.t("bt.cancel")
                                                                    : (modelData.paired ? root.t("bt.connect")
                                                                                        : root.t("bt.pair"))))
                                            color: modelData.connected
                                                       ? root.alpha(root.theme.subtext, 0.95)
                                                       : root.theme.accentSoft
                                            font.family: root.mono
                                            font.pixelSize: 8
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            enabled: barWindow.btAdapter && barWindow.btAdapter.enabled
                                            onClicked: {
                                                if (modelData.connected
                                                        || modelData.state === BluetoothDeviceState.Connecting)
                                                    modelData.disconnect()
                                                else if (modelData.pairing)
                                                    modelData.cancelPair()
                                                else if (root.btPairingAddress === modelData.address) {
                                                    btPairProc.running = false
                                                    root.btPairingAddress = ""
                                                } else if (modelData.paired)
                                                    modelData.connect()
                                                else {
                                                    root.btPairingAddress = modelData.address
                                                    btPairProc.target = modelData.address
                                                    btPairProc.running = true
                                                }
                                            }
                                        }
                                    }
                                }

                                HoverHandler {
                                    id: deviceHover
                                }
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            visible: barWindow.btList.length === 0
                            text: barWindow.btAdapter && barWindow.btAdapter.enabled
                                      ? (barWindow.btAdapter.discovering
                                             ? root.t("bt.searching")
                                             : root.t("bt.noDevices"))
                                      : root.t("bt.off")
                            color: root.alpha(root.theme.subtext, 0.75)
                            font.family: root.mono
                            font.pixelSize: 9
                            horizontalAlignment: Text.AlignHCenter
                            topPadding: 8
                            bottomPadding: 8
                        }
                    }
                }
            }

            // Popup anclado al icono de volumen: selector de salidas y entradas.
            PopupWindow {
                id: audioPopup
                anchor.item: volText
                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
                anchor.adjustment: PopupAdjustment.Slide | PopupAdjustment.Flip
                anchor.margins.bottom: -8

                visible: barWindow.audioOpen && !barWindow.hiddenByFullscreen
                grabFocus: true
                implicitWidth: 340
                implicitHeight: audioPopupColumn.implicitHeight + 24
                color: "transparent"

                onVisibleChanged: {
                    if (visible) {
                        root.refreshAudio()
                    } else if (barWindow.audioOpen) {
                        barWindow.audioOpen = false
                    }
                }

                Timer {
                    interval: 2500
                    running: barWindow.audioOpen
                    repeat: true
                    onTriggered: root.refreshAudio()
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 14
                    color: root.theme.bg
                    border.width: 1
                    border.color: root.alpha(root.theme.accent, 0.30)

                    Shortcut {
                        sequence: "Escape"
                        onActivated: barWindow.audioOpen = false
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: 1
                        height: 2
                        radius: 1
                        color: root.alpha(root.theme.accent, 0.55)
                    }

                    ColumnLayout {
                        id: audioPopupColumn
                        x: 12
                        y: 12
                        width: parent.width - 24
                        spacing: 7

                        // Cabecera
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Text {
                                Layout.alignment: Qt.AlignVCenter
                                text: root.volumeMuted ? "\uf026"
                                                       : (root.volumePercent > 60 ? "\uf028" : "\uf027")
                                color: root.theme.accent
                                font.family: root.mono
                                font.pixelSize: 16
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0

                                Text {
                                    Layout.fillWidth: true
                                    text: root.t("audio.title")
                                    color: root.theme.text
                                    font.family: root.mono
                                    font.pixelSize: 12
                                    font.bold: true
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: root.t("audio.outputLine") + root.audioDefaultLabel(true)
                                    color: root.alpha(root.theme.subtext, 0.85)
                                    font.family: root.mono
                                    font.pixelSize: 8
                                    elide: Text.ElideRight
                                }
                            }

                            Text {
                                Layout.alignment: Qt.AlignVCenter
                                text: root.volumeMuted ? root.t("audio.silenced") : root.volumePercent + "%"
                                color: root.volumeMuted ? root.theme.red : root.theme.accentSoft
                                font.family: root.mono
                                font.pixelSize: 9
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 1
                            color: root.alpha(root.theme.accent, 0.12)
                        }

                        Text {
                            Layout.fillWidth: true
                            text: root.t("audio.output")
                            color: root.alpha(root.theme.subtext, 0.75)
                            font.family: root.mono
                            font.pixelSize: 8
                            font.bold: true
                            topPadding: 1
                        }

                        Repeater {
                            model: root.audioSinks

                            delegate: Rectangle {
                                required property var modelData

                                Layout.fillWidth: true
                                Layout.preferredHeight: 38
                                radius: 9
                                color: root.audioDefaultSink === modelData.name
                                           ? root.alpha(root.theme.accent, 0.10)
                                           : (sinkHover.hovered
                                                  ? root.alpha(root.theme.accent, 0.08)
                                                  : "transparent")
                                border.width: root.audioDefaultSink === modelData.name ? 1 : 0
                                border.color: root.alpha(root.theme.accent, 0.30)

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 9
                                    anchors.rightMargin: 9
                                    spacing: 9

                                    Text {
                                        Layout.alignment: Qt.AlignVCenter
                                        text: root.audioIcon(modelData, true)
                                        color: root.audioDefaultSink === modelData.name
                                                   ? root.theme.accent
                                                   : root.alpha(root.theme.subtext, 0.9)
                                        font.family: root.mono
                                        font.pixelSize: 13
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignVCenter
                                        text: root.audioLabel(modelData)
                                        color: root.audioDefaultSink === modelData.name
                                                   ? root.theme.text
                                                   : root.alpha(root.theme.text, 0.85)
                                        font.family: root.mono
                                        font.pixelSize: 9
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignVCenter
                                        visible: root.audioDefaultSink === modelData.name
                                        text: "\uf00c"
                                        color: root.theme.accent
                                        font.family: root.mono
                                        font.pixelSize: 9
                                    }
                                }

                                HoverHandler {
                                    id: sinkHover
                                    cursorShape: Qt.PointingHandCursor
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.setAudioSink(modelData.name)
                                }
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            visible: root.audioSinks.length === 0
                            text: root.t("audio.noOutputs")
                            color: root.alpha(root.theme.subtext, 0.7)
                            font.family: root.mono
                            font.pixelSize: 8
                            horizontalAlignment: Text.AlignHCenter
                            topPadding: 4
                            bottomPadding: 4
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 1
                            color: root.alpha(root.theme.accent, 0.12)
                        }

                        Text {
                            Layout.fillWidth: true
                            text: root.t("audio.input")
                            color: root.alpha(root.theme.subtext, 0.75)
                            font.family: root.mono
                            font.pixelSize: 8
                            font.bold: true
                            topPadding: 1
                        }

                        Repeater {
                            model: root.audioSources

                            delegate: Rectangle {
                                required property var modelData

                                Layout.fillWidth: true
                                Layout.preferredHeight: 38
                                radius: 9
                                color: root.audioDefaultSource === modelData.name
                                           ? root.alpha(root.theme.accent, 0.10)
                                           : (sourceHover.hovered
                                                  ? root.alpha(root.theme.accent, 0.08)
                                                  : "transparent")
                                border.width: root.audioDefaultSource === modelData.name ? 1 : 0
                                border.color: root.alpha(root.theme.accent, 0.30)

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 9
                                    anchors.rightMargin: 9
                                    spacing: 9

                                    Text {
                                        Layout.alignment: Qt.AlignVCenter
                                        text: root.audioIcon(modelData, false)
                                        color: root.audioDefaultSource === modelData.name
                                                   ? root.theme.accent
                                                   : root.alpha(root.theme.subtext, 0.9)
                                        font.family: root.mono
                                        font.pixelSize: 13
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignVCenter
                                        text: root.audioLabel(modelData)
                                        color: root.audioDefaultSource === modelData.name
                                                   ? root.theme.text
                                                   : root.alpha(root.theme.text, 0.85)
                                        font.family: root.mono
                                        font.pixelSize: 9
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignVCenter
                                        visible: root.audioDefaultSource === modelData.name
                                        text: "\uf00c"
                                        color: root.theme.accent
                                        font.family: root.mono
                                        font.pixelSize: 9
                                    }
                                }

                                HoverHandler {
                                    id: sourceHover
                                    cursorShape: Qt.PointingHandCursor
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.setAudioSource(modelData.name)
                                }
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            visible: root.audioSources.length === 0
                            text: root.t("audio.noInputs")
                            color: root.alpha(root.theme.subtext, 0.7)
                            font.family: root.mono
                            font.pixelSize: 8
                            horizontalAlignment: Text.AlignHCenter
                            topPadding: 4
                            bottomPadding: 4
                        }

                        Text {
                            Layout.fillWidth: true
                            text: root.t("audio.clickDefault")
                            color: root.alpha(root.theme.subtext, 0.55)
                            font.family: root.mono
                            font.pixelSize: 8
                            horizontalAlignment: Text.AlignHCenter
                            topPadding: 2
                        }
                    }
                }
            }
        }
    }
}
