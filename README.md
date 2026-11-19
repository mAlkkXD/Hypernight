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

Un solo comando:

```bash
curl -fsSL https://raw.githubusercontent.com/mAlkkXD/Hypernight/main/install.sh | bash
```

Clona en `~/Hypernight` (o actualiza si ya existe), **instala las dependencias** y después crea los symlinks. Lo que ya exista se mueve a `~/.dotfiles-backup/<fecha>/`.

El orden es siempre el mismo: primero los paquetes, luego los dotfiles.

También se puede hacer manual:

```bash
git clone https://github.com/mAlkkXD/Hypernight.git
cd Hypernight
./install.sh --dry-run   # ver qué haría
./install.sh             # dependencias + dotfiles
```

O con `make install`, `make dry-run` y `make update`.

### Opciones

| Flag | Efecto |
|---|---|
| `--dry-run` | Muestra lo que haría sin tocar nada |
| `--no-deps` | Solo aplica los dotfiles, sin instalar paquetes |
| `--deps-only` | Solo instala dependencias, sin tocar los dotfiles |

Con `curl | bash` los flags se pasan así:

```bash
curl -fsSL https://raw.githubusercontent.com/mAlkkXD/Hypernight/main/install.sh | bash -s -- --no-deps
```

Variables: `HYPERNIGHT_DIR` cambia el destino del clon.

### Dependencias

El instalador usa `pacman` (Arch/CachyOS) y, si no existe, `apt`, `dnf` o `zypper`. Los paquetes que solo están en AUR se instalan con `yay` o `paru` si están disponibles.

```
git curl
hyprland quickshell swaybg
kitty dolphin pavucontrol
dunst fuzzel cava btop starship fish
matugen imagemagick python
grim slurp swappy wl-clipboard cliphist hyprshot
hypridle hyprlock wlogout
networkmanager bluez bluez-utils
brightnessctl playerctl
pipewire wireplumber pipewire-pulse
xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
libnotify kvantum ttf-jetbrains-mono-nerd
```

Fuentes e iconos del rice (`candy-icons`, `mizuki-psekai-cursor`, `Google Sans Flex`) no están en los repos oficiales y hay que ponerlos a mano.

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
