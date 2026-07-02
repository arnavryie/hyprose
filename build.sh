#!/usr/bin/env bash
# build.sh — Hyprose ISO build wrapper
# Runs as root (CI container or `sudo ./build.sh` locally on Arch)

set -euo pipefail

PINK='\033[1;35m'; CYAN='\033[0;36m'; GREEN='\033[0;32m'
YELLOW='\033[1;33m'; RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

log()  { echo -e "${CYAN}[build]${RESET} $*"; }
ok()   { echo -e "${GREEN}[  OK ]${RESET} $*"; }
warn() { echo -e "${YELLOW}[ WARN]${RESET} $*"; }
err()  { echo -e "${RED}[ FAIL]${RESET} $*"; exit 1; }

PROFILE_DIR="$(cd "$(dirname "$0")/hyprose" && pwd)"
WORK_DIR="/tmp/hyprose-work"
OUT_DIR="$(cd "$(dirname "$0")" && pwd)/out"
RELENG="/usr/share/archiso/configs/releng"

[[ $EUID -ne 0 ]] && err "Run as root."
command -v mkarchiso &>/dev/null || err "archiso not installed. Run: pacman -S archiso"
[[ -d "$RELENG" ]] || err "releng profile not found at $RELENG — is archiso installed?"

echo -e "${PINK}${BOLD}"
echo "  ============================================"
echo "       Hyprose ISO Builder"
echo "  ============================================"
echo -e "${RESET}"
log "Profile: $PROFILE_DIR"
log "Output:  $OUT_DIR"

# -- Clean flag --------------------------------------------------------------
if [[ "${1:-}" == "--clean" ]]; then
    warn "Cleaning work directory..."
    rm -rf "$WORK_DIR"
    ok "Cleaned."
fi

# -- Vendor boot configs from official releng profile ------------------------
# These MUST match the installed archiso version, so they are copied fresh
# every build and never committed to the repo.
log "Vendoring boot configs from releng..."
for d in syslinux efiboot grub; do
    if [[ -d "$RELENG/$d" ]]; then
        rm -rf "${PROFILE_DIR:?}/$d"
        cp -r "$RELENG/$d" "$PROFILE_DIR/$d"
        ok "Copied $d/"
    fi
done

# Rebrand boot menu text
grep -rl "Arch Linux" "$PROFILE_DIR/syslinux" "$PROFILE_DIR/efiboot" "$PROFILE_DIR/grub" 2>/dev/null \
    | xargs -r sed -i 's/Arch Linux/Hyprose Linux/g' || true
ok "Boot menus rebranded to Hyprose."

# -- Vendor dots (skipped if CI already did it) -------------------------------
if [[ -d "$PROFILE_DIR/airootfs/etc/skel/.config" ]]; then
    ok "Dots already vendored, skipping."
else
    log "Vendoring hyprose-dots into airootfs..."
    rm -rf /tmp/hyprose-dots
    git clone --depth=1 --recurse-submodules \
        https://github.com/arnavryie/hyprose-dots.git /tmp/hyprose-dots
    mkdir -p "$PROFILE_DIR/airootfs/etc/skel"
    rsync -a /tmp/hyprose-dots/dots/ "$PROFILE_DIR/airootfs/etc/skel/"
    mkdir -p "$PROFILE_DIR/airootfs/usr/share/hyprose"
    rsync -a --exclude='.git' /tmp/hyprose-dots/ "$PROFILE_DIR/airootfs/usr/share/hyprose/dots/"
    ok "Dots vendored."
fi

# -- Build --------------------------------------------------------------------
mkdir -p "$WORK_DIR" "$OUT_DIR"
log "Starting ISO build (20-60 minutes)..."
START_TIME=$(date +%s)

mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" -m iso "$PROFILE_DIR"

END_TIME=$(date +%s)
ELAPSED=$(( END_TIME - START_TIME ))
ok "Build completed in $(( ELAPSED / 60 ))m $(( ELAPSED % 60 ))s"

# -- Checksum -----------------------------------------------------------------
ISO_FILE=$(find "$OUT_DIR" -name "hyprose-*.iso" | sort | tail -1)
[[ -z "$ISO_FILE" ]] && err "ISO not found in $OUT_DIR"

sha256sum "$ISO_FILE" > "${ISO_FILE}.sha256"
ok "ISO:  $ISO_FILE"
ok "Size: $(du -sh "$ISO_FILE" | awk '{print $1}')"
ok "Hash: ${ISO_FILE}.sha256"
