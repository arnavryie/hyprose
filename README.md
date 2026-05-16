# 🌹 Hyprose

> **Arch Linux + Hyprland + end-4's dots — out of the box.**

[![Build ISO](https://github.com/hyprose/hyprose-iso/actions/workflows/build-iso.yml/badge.svg)](https://github.com/hyprose/hyprose-iso/actions)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Hyprose is a ready-to-rice Arch Linux distribution that ships with [end-4's dots-hyprland](https://github.com/end-4/dots-hyprland) pre-configured. No more black screens, no more dependency hell — just boot the ISO, click "Install", and get a fully functional Hyprland rice.

![Hyprose Desktop](https://raw.githubusercontent.com/hyprose/hyprose-iso/main/screenshots/desktop.png)

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🌹 **end-4 dots** | Full Material You theming with dynamic colors |
| 🤖 **AI Sidebar** | Built-in Gemini, Ollama, and ChatGPT integration |
| 🎯 **Overview** | macOS Exposé-style window overview |
| 🎨 **Material You** | Colors auto-generated from wallpaper |
| ⌨️ **Familiar Keybinds** | `Super+/` for help, `Super+Return` for terminal |
| 🖥️ **GPU Auto-Detect** | NVIDIA (proprietary), AMD, Intel — all supported |
| 📦 **Calamares GUI** | Beautiful graphical installer |
| 🔄 **Rolling Release** | Based on Arch Linux, always up-to-date |

## 🚀 Quick Start

### Download & Install

1. **Download** the latest ISO from [Releases](https://github.com/hyprose/hyprose-iso/releases)
2. **Flash** to USB with [balenaEtcher](https://www.balena.io/etcher/) or `dd`
3. **Boot** from USB → Live session loads Hyprland automatically
4. **Click** "Install Hyprose" on the desktop
5. **Follow** the Calamares wizard (5 minutes)
6. **Reboot** → Your rice is ready!

### First Boot

- Hyprland starts automatically on TTY1
- Press `Super+/` to see all keybinds
- Right-click desktop or use `Super+Shift+E` for app launcher
- AI sidebar: `Super+Shift+A`
- Overview: `Super+Tab`

## 🛠️ Build from Source

```bash
# On Arch Linux (or VM/container)
sudo pacman -S archiso

git clone https://github.com/hyprose/hyprose-iso.git
cd hyprose-iso/hyprose

# Build (30-60 minutes, ~20GB space needed)
sudo mkarchiso -v -w /tmp/hyprose-work .

# ISO appears in: out/
ls out/*.iso
```

## 📁 Repository Structure

```
hyprose-iso/
├── hyprose/                    # archiso profile (the build recipe)
│   ├── packages.x86_64         # All packages for live + installed system
│   ├── profiledef.sh           # ISO metadata & boot config
│   ├── pacman.conf             # Pacman config with Chaotic AUR
│   └── airootfs/               # Overlay files for live system
│       ├── etc/
│       │   ├── skel/           # Default user configs
│       │   ├── systemd/        # Auto-login service
│       │   └── ...
│       └── usr/
│           ├── local/bin/
│           │   ├── hyprose-live-setup    # Init dots in live session
│           │   ├── hyprose-installer     # Terminal installer (fallback)
│           │   └── hyprose-first-boot    # Post-install setup
│           └── share/calamares/        # GUI installer config
│               ├── branding/hyprose/     # Hyprose theme
│               └── modules/            # Installer steps
├── .github/
│   └── workflows/
│       └── build-iso.yml       # Auto-build ISOs on GitHub
├── README.md
├── CONTRIBUTING.md
└── LICENSE
```

## 🎨 Customization

### Pre-Build (in the ISO)

Edit these before building to customize your ISO:

| File | What to Change |
|------|---------------|
| `hyprose/packages.x86_64` | Add/remove packages |
| `hyprose/airootfs/usr/local/share/backgrounds/hyprose/` | Add wallpapers |
| `hyprose/airootfs/usr/share/calamares/branding/hyprose/` | Installer theme |
| `hyprose/airootfs/usr/local/bin/hyprose-installer` | Partitioning logic |

### Post-Install (on your system)

After installation, customize like any end-4 dots setup:

```bash
# Change wallpaper (auto-generates colors)
~/.config/hypr/scripts/wallpaper.sh /path/to/wallpaper.jpg

# Edit keybinds
nano ~/.config/hypr/hyprland.conf

# Customize Quickshell widgets
# Edit files in ~/.config/quickshell/

# Switch color scheme
# Use the sidebar or edit ~/.config/hypr/scripts/material-colors/
```

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| Black screen after boot | Add `nomodeset` to GRUB boot params, then install proper GPU drivers |
| NVIDIA issues | Boot with `nvidia-drm.modeset=1`, or use `nvidia-open-dkms` for RTX 4000+ |
| WiFi not working | `nmcli device wifi list` → `nmcli device wifi connect SSID password PASSWORD` |
| Installer crashes | Check `/tmp/hyprose-install.log`, report with GPU model |
| Quickshell not loading | Check `~/.config/quickshell/` exists, run `quickshell` manually to see errors |

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

- **Test on real hardware** — especially NVIDIA GPUs
- **Report bugs** with `/tmp/hyprose-install.log` attached
- **Suggest features** that make Hyprland ricing easier
- **Translate** the Calamares installer

## 📜 License

GPL-3.0 — See [LICENSE](LICENSE) for details.

Hyprose includes software from:
- [Arch Linux](https://archlinux.org) (GPL-2.0/GPL-3.0)
- [Hyprland](https://hyprland.org) (BSD-3-Clause)
- [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) (GPL-3.0)
- [Quickshell](https://quickshell.dev) (GPL-3.0)
- [Calamares](https://calamares.io) (GPL-3.0)

## 🙏 Credits

- **[end-4](https://github.com/end-4)** — The incredible dotfiles that make this possible
- **[clsty](https://github.com/clsty)** — The install script we adapted
- **Arch Linux team** — For `archiso` and the base system
- **Hyprland team** — For the best Wayland compositor
- **Quickshell team** — For the widget framework

---

<p align="center">
  <b>🌹 Made with love for the ricing community</b><br>
  <a href="https://hyprose.org">Website</a> • 
  <a href="https://discord.gg/hyprose">Discord</a> • 
  <a href="https://github.com/hyprose/hyprose-iso">GitHub</a>
</p>
