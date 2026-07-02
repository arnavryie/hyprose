# Hyprose live session — launch desktop on tty1
if [[ -z "${WAYLAND_DISPLAY:-}" && "$(tty)" == "/dev/tty1" ]]; then
    exec /usr/local/bin/hyprose-live-setup
fi
