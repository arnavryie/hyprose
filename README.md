# 🌹 Hyprose Linux

> Arch Linux + end-4's dots-hyprland — zero config, out of the box.

[![Build ISO](https://github.com/arnavryie/hyprose/actions/workflows/build.yml/badge.svg)](https://github.com/arnavryie/hyprose/actions/workflows/build.yml)
![License](https://img.shields.io/badge/license-GPL--3.0-pink)
![Arch](https://img.shields.io/badge/base-Arch%20Linux-1793d1?logo=arch-linux)
![Hyprland](https://img.shields.io/badge/WM-Hyprland-brightgreen)

---

## What is Hyprose?

Hyprose is an Arch-based Linux distribution that ships [end-4's dots-hyprland](https://github.com/end-4/dots-hyprland) pre-configured. Boot the ISO, install, reboot — you have a fully riced Hyprland desktop without touching a config file.

**It's for people who want:**
- A real Arch system (not a fork, just pacstrap + dots)
- end-4's rice without manually running their installer
- GPU auto-detection (NVIDIA/AMD/Intel all handled)
- Material You theming auto-generated from your wallpaper

---

## Features

| Feature | Status |
|---|---|
| Zero-config Hyprland (end-4 dots) | ✅ |
| TUI installer (UEFI + BIOS) | ✅ |
| GPU auto-detection | ✅ |
| Material You theming (matugen) | ✅ |
| Chaotic AUR pre-configured | ✅ |
| Quickshell / AGS widgets | ✅ |
| Auto-login live session | ✅ |
| First-boot setup wizard | ✅ |
| GitHub Actions ISO builder | ✅ |

---

## Build

### Requirements
- Arch Linux (or Arch in a VM/container)
- `archiso` package
- 20GB+ free disk space
- Internet connection

### Quick Build

```bash
# Install archiso
sudo pacman -S archiso git

# Clone
git clone https://github.com/arnavryie/hyprose.git
cd hyprose

# Build (takes 20-60 min)
sudo ./build.sh

# ISO lands in ./out/
```

### Clean rebuild

```bash
sudo ./build.sh --clean
```

### Test in QEMU

```bash
qemu-system-x86_64 -enable-kvm -m 4G -cdrom out/hyprose-*.iso -boot d
```

---

## File Structure

```
hyprose/
├── build.sh                        ← ISO build wrapper
├── hyprose/
│   ├── profiledef.sh               ← archiso ISO metadata
│   ├── packages.x86_64             ← all packages for the ISO
│   ├── pacman.conf                 ← pacman config (Chaotic AUR included)
│   └── airootfs/
│       ├── etc/
│       │   ├── os-release          ← Hyprose branding
│       │   ├── lsb-release
│       │   ├── skel/.bashrc        ← default user shell config
│       │   ├── systemd/system/
│       │   │   └── getty@tty1.service.d/
│       │   │       └── autologin.conf   ← live session autologin
│       │   └── polkit-1/rules.d/
│       │       └── 49-nopasswd-live.rules
│       └── usr/local/bin/
│           ├── hyprose-live-setup  ← clones + starts dots in live session
│           ├── hyprose-installer   ← main TUI installer
│           └── hyprose-first-boot  ← post-install first boot setup
└── .github/workflows/
    └── build.yml                   ← GitHub Actions ISO builder
```

---

## Install Flow

```
Boot ISO → Auto-login → hyprose-live-setup → Hyprland starts
                                                    ↓
                                          Click "Install Hyprose"
                                                    ↓
                                         hyprose-installer TUI
                                     (disk → format → pacstrap → bootloader)
                                                    ↓
                                              Reboot
                                                    ↓
                                         hyprose-first-boot
                                   (matugen colors → services → welcome)
```

---

## Customization

**Add packages:** Edit `hyprose/packages.x86_64`

**Change partitioning:** Edit the `sgdisk` calls in `airootfs/usr/local/bin/hyprose-installer`

**Add wallpapers:** Drop them in `airootfs/usr/local/share/backgrounds/hyprose/`

**Change default timezone/locale:** Edit the chroot block in `hyprose-installer`

---

## Roadmap

- [x] archiso profile skeleton
- [x] Full package list with GPU drivers
- [x] TUI installer (UEFI + BIOS)
- [x] Live session auto-login + dots setup
- [x] First boot Material You theming
- [x] GitHub Actions build pipeline
- [ ] Calamares GUI installer
- [ ] Custom GRUB/systemd-boot theme
- [ ] Btrfs + snapshots support
- [ ] ARM64 support

---

## Credits

- [end-4](https://github.com/end-4) — the dots-hyprland rice
- [clsty](https://github.com/clsty) — the install script
- Arch Linux team — archiso

## License

GPL-3.0 — same as Arch Linux and end-4's dotfiles.
