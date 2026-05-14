# 🌹 Hyprose Archiso Profile

## What is this?
This is the official `archiso` profile for building **Hyprose** — an Arch Linux-based distribution that ships with [end-4's dots-hyprland](https://github.com/end-4/dots-hyprland) pre-configured.

## Build Requirements
- Arch Linux (or container/VM with Arch)
- `archiso` package installed
- At least 20GB free space
- Internet connection

## Quick Build

```bash
# Install archiso
sudo pacman -S archiso

# Clone this profile
git clone https://github.com/hyprose/hyprose-archiso.git
cd hyprose-archiso

# Build the ISO (takes 30-60 minutes)
sudo mkarchiso -v -w /tmp/hyprose-work hyprose/

# The ISO will be in hyprose/out/
```

## What the ISO does
1. **Boot** → GRUB/systemd-boot menu
2. **Live Session** → Auto-logs into `hyprose` user, starts Hyprland with full end-4 rice
3. **Desktop** → "Install Hyprose" icon ready to click
4. **Installer** → GUI/TUI wizard: pick disk, keyboard, username, password
5. **Install** → Formats disk, installs base system + Hyprland + end-4 dots
6. **First Boot** → Auto-generates colors from wallpaper, shows welcome

## Key Features
- **Zero-config Hyprland**: end-4's full dotfiles out of the box
- **GPU auto-detection**: NVIDIA (proprietary), AMD, Intel
- **Chaotic AUR**: Pre-configured for bleeding-edge packages
- **Quickshell**: Beautiful widgets, overview, AI sidebar
- **Material You**: Dynamic theming from wallpaper
- **AUR Helpers**: `yay` and `paru` pre-installed

## File Structure
```
hyprose/
├── packages.x86_64          # Package list for live + installed system
├── profiledef.sh             # ISO metadata
├── pacman.conf               # Pacman config with Chaotic AUR
├── airootfs/                 # Overlay files for the live system
│   ├── etc/
│   │   ├── skel/             # Default user configs
│   │   ├── systemd/            # Auto-login service
│   │   ├── polkit-1/         # Permission rules
│   │   └── ...
│   └── usr/local/bin/
│       ├── hyprose-live-setup    # Initialize dots in live session
│       ├── hyprose-installer     # The main installer
│       └── hyprose-first-boot    # Post-install setup
```

## Customization
- Edit `packages.x86_64` to add/remove packages
- Modify `airootfs/usr/local/bin/hyprose-installer` for partitioning logic
- Add wallpapers to `airootfs/usr/local/share/backgrounds/hyprose/`
- Customize Calamares branding in `airootfs/usr/share/calamares/branding/hyprose/`

## License
GPL-3.0 — Same as Arch Linux and end-4's dotfiles.

## Credits
- [end-4](https://github.com/end-4) for the incredible dotfiles
- [clsty](https://github.com/clsty) for the install script
- Arch Linux team for `archiso`
