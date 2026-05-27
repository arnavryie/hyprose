#!/usr/bin/env bash
# build.sh — Hyprose ISO build wrapper
# Usage: sudo ./build.sh [--clean]

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
ARCHISO_VERSION=$(pacman -Q archiso 2>/dev/null | awk '{print $2}' || echo "unknown")

[[ $EUID -ne 0 ]] && err "Run as root: sudo ./build.sh"
command -v mkarchiso &>/dev/null || err "archiso not installed. Run: sudo pacman -S archiso"

# ── Banner ─────────────────────────────────────────────────────────────────
clear
echo -e "${PINK}${BOLD}"
echo "  ╔══════════════════════════════════════╗"
echo "  ║     🌹 Hyprose ISO Builder           ║"
echo "  ╚══════════════════════════════════════╝"
echo -e "${RESET}"
log "archiso version: $ARCHISO_VERSION"
log "Profile: $PROFILE_DIR"
log "Work dir: $WORK_DIR"
log "Output: $OUT_DIR"
echo ""

# ── Clean flag ─────────────────────────────────────────────────────────────
if [[ "${1:-}" == "--clean" ]]; then
    warn "Cleaning work directory..."
    rm -rf "$WORK_DIR"
    ok "Cleaned."
fi

# ── Create dirs ────────────────────────────────────────────────────────────
mkdir -p "$WORK_DIR" "$OUT_DIR"

# ── Build ──────────────────────────────────────────────────────────────────
log "Starting ISO build (this takes 20-60 minutes)..."
START_TIME=$(date +%s)

mkarchiso -v \
    -w "$WORK_DIR" \
    -o "$OUT_DIR" \
    "$PROFILE_DIR" 2>&1 | tee /tmp/hyprose-build.log

BUILD_EXIT=${PIPESTATUS[0]}
END_TIME=$(date +%s)
ELAPSED=$(( END_TIME - START_TIME ))
ELAPSED_MIN=$(( ELAPSED / 60 ))
ELAPSED_SEC=$(( ELAPSED % 60 ))

if [[ $BUILD_EXIT -ne 0 ]]; then
    err "Build failed after ${ELAPSED_MIN}m ${ELAPSED_SEC}s. Check /tmp/hyprose-build.log"
fi

ok "Build completed in ${ELAPSED_MIN}m ${ELAPSED_SEC}s"

# ── Find ISO + checksum ────────────────────────────────────────────────────
ISO_FILE=$(find "$OUT_DIR" -name "hyprose-*.iso" | sort | tail -1)
if [[ -z "$ISO_FILE" ]]; then
    err "ISO not found in $OUT_DIR"
fi

ISO_SIZE=$(du -sh "$ISO_FILE" | awk '{print $1}')
log "Generating checksums..."
sha256sum "$ISO_FILE" > "${ISO_FILE}.sha256"
ok "SHA256: $(cat "${ISO_FILE}.sha256" | awk '{print $1}')"

echo ""
echo -e "${PINK}${BOLD}  ✓ ISO ready!${RESET}"
echo -e "  File:  ${CYAN}$ISO_FILE${RESET}"
echo -e "  Size:  ${ISO_SIZE}"
echo -e "  Hash:  ${ISO_FILE}.sha256"
echo ""
echo -e "  ${YELLOW}Test with:${RESET} qemu-system-x86_64 -enable-kvm -m 4G -cdrom '$ISO_FILE' -boot d"
