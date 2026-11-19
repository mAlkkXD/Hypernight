# Hypernight

Dotfiles de Hyprland con una barra y un control center hechos en Quickshell, acento automático desde el wallpaper y selector de fondos en mosaico hexagonal.

## Estructura

```
home/.config/        configuración de Hyprland, Quickshell, terminales, dunst, fuzzel, cava, btop, fish, matugen, GTK y Kvantum
home/.bashrc .zshrc
wallpapers/WPForDF/  fondos usados por el selector
scripts/             comprobación de secretos
install.sh           instalación por symlinks
```

## Instalación

```bash
git clone https://github.com/mAlkkXD/Hypernight.git
cd Hypernight
./install.sh --dry-run   # ver qué haría
./install.sh             # crear symlinks y respaldar lo existente
```

Lo que ya exista se mueve a `~/.dotfiles-backup/<fecha>/`.

### Dependencias

```
hyprland quickshell swaybg kitty dunst fuzzel cava btop matugen
grim slurp swappy wl-clipboard cliphist hypridle hyprlock wlogout
networkmanager bluez-utils brightnessctl playerctl
```

Fuentes: `JetBrainsMono Nerd Font`. Para el acento automático se usa `magick` (ImageMagick).

Después de instalar, ajusta:

- `~/.config/hypr/conf/monitors.lua` para tus salidas.
- `~/.config/quickshell/wallpaper.json` con las rutas de tus fondos.
- Arranca la sesión de Hyprland: `quickshell -n`, `dunst`, `hypridle` y `wallpaper.sh restore` se lanzan desde `autostart.lua`.

## Atajos principales

| Atajo | Acción |
|---|---|
| `Super+Return` | terminal (kitty) |
| `Super+R` | lanzador (fuzzel) |
| `Super+X` | control center |
| `Super+W` | selector de fondos |
| `Super+V` | historial de portapapeles |
| `Super+A` | pavucontrol |
| `Super+Escape` | menú de apagado |
| `Super+F` | pantalla completa |
| `Super+Space` | flotante |
| `Super+1..0` | workspaces |
| `Print` / `Shift+Print` | captura de región / completa |

La lista completa está en `home/.config/hypr/conf/keybinds.lua`.

## Acento automático

`scripts/accent-from-wallpaper.sh` toma el wallpaper del monitor enfocado desde `wallpaper.json`, extrae el tono dominante y actualiza `theme.json`. Quickshell lo vigila y recolorea la interfaz. `recolor.sh` hace lo mismo con matugen.

## Secretos

`scripts/check-secrets.sh` escanea claves de API, tokens y claves privadas. Está enganchado como hook de pre-commit:

```bash
git config core.hooksPath .githooks
```

También lee `~/.config/hypernight/deny.txt` (fuera del repo) con cadenas que nunca deben subirse.
