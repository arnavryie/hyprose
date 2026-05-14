#!/bin/bash
# Hyprose live session autostart

if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    # Start Hyprland for live session
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_DESKTOP=Hyprland
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland
    export SDL_VIDEODRIVER=wayland

    # Initialize the full end-4 dotfiles
    if [ -f /usr/local/bin/hyprose-live-setup ]; then
        /usr/local/bin/hyprose-live-setup
    fi

    exec Hyprland
fi
