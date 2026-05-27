# 🌹 Hyprose — Full Build Prompt for Claude

## Context

This is the GitHub repo: https://github.com/arnavryie/hyprose

**Hyprose** is an Arch Linux ISO (built with `archiso`) that ships [end-4's dots-hyprland](https://github.com/end-4/dots-hyprland) pre-configured out of the box. Think: pop-os/endeavourOS but for Hyprland enthusiasts.

The repo currently has only a README describing what it SHOULD do. Every shell script and config file is either missing or empty. You need to build the full archiso profile from scratch.

---

## What You Failed At (and Must Fix)

1. **`profiledef.sh`** — missing. Archiso won't even start `mkarchiso` without this. Needs correct `iso_name`, `iso_label`, `iso_publisher`, `install_dir`, `bootmodes`, and `airootfs_image_type`.

2. **`packages.x86_64`** — missing. The entire package list for the ISO. Needs: base system, Hyprland + deps, end-4 dots deps (ags/quickshell, eww, swww, etc.), GPU drivers (nvidia/amd/intel), AUR helper, Calamares installer, fonts, pipewire, all of it.

3. **`pacman.conf`** — missing. Needs Chaotic AUR repo added (`https://cdn-mirror.chaotic.cx`) with proper keyring import commands documented.

4. **`airootfs/etc/systemd/system/getty@tty1.service.d/autologin.conf`** — missing. Without this the live session doesn't auto-login to the `hyprose` user and Hyprland never starts.

5. **`airootfs/usr/local/bin/hyprose-live-setup`** — missing. The script that runs on live boot to clone end-4's dots, run their install script non-interactively, and set up the desktop.

6. **`airootfs/usr/local/bin/hyprose-installer`** — missing. The MAIN installer script. Needs: disk selection (lsblk), partition scheme (EFI + swap + root), format (mkfs.fat/mkfs.ext4), pacstrap, genfstab, arch-chroot setup, bootloader (systemd-boot), user creation, mkinitcpio, and dots installation.

7. **`airootfs/usr/local/bin/hyprose-first-boot`** — missing. Runs once after install. Triggers `matugen` for Material You colors from wallpaper, enables services, shows welcome notification.

8. **`airootfs/etc/skel/.bashrc`** — needs Hyprose branding, useful aliases, and `fastfetch` call on login.

---

## Phases You Must Complete IN ORDER

### Phase 1 — Skeleton (archiso minimum viable)
- `profiledef.sh` with correct fields
- `packages.x86_64` with base packages
- `pacman.conf` with Chaotic AUR
- `airootfs/etc/systemd/system/getty@tty1.service.d/autologin.conf`

### Phase 2 — Full Package List
Expand `packages.x86_64` with ALL deps for end-4 dots-hyprland:
- `hyprland`, `hyprlock`, `hypridle`, `hyprpicker`, `hyprshot`
- `ags` or `quickshell` (from Chaotic AUR)
- `eww`, `swww`, `waybar` (fallback)
- `matugen` (Material You color gen)
- `nwg-look`, `nwg-bar`, `nwg-panel`
- `pipewire`, `wireplumber`, `pipewire-pulse`, `pavucontrol`
- `thunar`, `gvfs`, `tumbler`
- `starship`, `zsh`, `oh-my-zsh` (optional)
- `noto-fonts`, `noto-fonts-emoji`, `ttf-jetbrains-mono-nerd`
- `mesa`, `vulkan-intel`, `vulkan-radeon`, `nvidia` (all 3 GPU stacks)
- `calamares` for GUI install
- `networkmanager`, `nm-connection-editor`
- `fastfetch`, `btop`, `bat`, `eza`, `fzf`

### Phase 3 — Live Setup Script
`hyprose-live-setup` must:
1. Check if running as `hyprose` user in live session
2. Clone `https://github.com/end-4/dots-hyprland` to `~/.config`
3. Run their `install.sh` in unattended/non-interactive mode
4. Copy wallpapers from `/usr/local/share/backgrounds/hyprose/`
5. Start Hyprland via `.bash_profile` or `exec Hyprland`

### Phase 4 — Installer Script
`hyprose-installer` must:
1. Welcome TUI (dialog/whiptail) — show distro name + version
2. Disk selection — `lsblk` parsed into a menu
3. Confirm wipe warning
4. Auto-partition: 512MB EFI, 4GB swap, rest as root
5. Format: `mkfs.fat -F32`, `mkswap`, `mkfs.ext4`
6. Mount and `pacstrap /mnt`
7. `genfstab -U /mnt >> /mnt/etc/fstab`
8. `arch-chroot` block: locale, timezone, hostname, user creation, sudo
9. Install systemd-boot + entries
10. Copy dots + enable `hyprose-first-boot.service`
11. Unmount + reboot prompt

### Phase 5 — First Boot Script
`hyprose-first-boot` must:
1. Run once (check `/etc/hyprose-firstboot-done`)
2. Run `matugen` on default wallpaper
3. Enable NetworkManager, pipewire services
4. `systemctl --user enable ags` or quickshell
5. Show welcome notification via `notify-send`
6. Create `~/.config/hyprose/user.conf` for per-user settings
7. Write `/etc/hyprose-firstboot-done` to prevent re-run

### Phase 6 — Self-Improvements You Should Add (do these on your own)
- `build.sh` — wrapper around `mkarchiso` with colored output, cleanup, and ISO checksum generation
- `airootfs/etc/os-release` — proper Hyprose branding so `neofetch`/`fastfetch` shows the right distro name
- `airootfs/etc/lsb-release` — same
- `airootfs/usr/share/pixmaps/hyprose-logo.png` — placeholder (create a simple SVG at minimum)
- `.github/workflows/build.yml` — GitHub Actions workflow to auto-build the ISO on push to main
- `CONTRIBUTING.md` — how to add packages, test locally with a VM
- Updated `README.md` — replace the "what it does" placeholder text with real build output, screenshots section, and a "Roadmap" with the phases above checked off

---

## Constraints / Rules

- All scripts must be `#!/usr/bin/env bash` with `set -euo pipefail`
- Installer must handle both UEFI and legacy BIOS (detect via `/sys/firmware/efi`)
- GPU detection: check `lspci` output for NVIDIA/AMD/Intel and install the right driver stack
- Colors: use ANSI escape codes for green/red/yellow status lines
- No hardcoded usernames except `hyprose` for the live user
- Installer-created user should be prompted interactively
- Every script must be `chmod +x`
- `packages.x86_64` — one package per line, no inline comments (archiso doesn't support them)

---

## Deliverables

Produce every file as a complete, ready-to-copy shell script. No placeholders. No `# TODO` lines. Working code only.

File tree expected:
```
hyprose/
├── profiledef.sh
├── packages.x86_64
├── pacman.conf
├── airootfs/
│   ├── etc/
│   │   ├── os-release
│   │   ├── lsb-release
│   │   ├── skel/
│   │   │   └── .bashrc
│   │   ├── systemd/system/getty@tty1.service.d/
│   │   │   └── autologin.conf
│   │   └── polkit-1/rules.d/
│   │       └── 49-nopasswd-live.rules
│   └── usr/local/bin/
│       ├── hyprose-live-setup
│       ├── hyprose-installer
│       └── hyprose-first-boot
├── build.sh
└── README.md (updated)
```
