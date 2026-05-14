# Hyprose default bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -la'
alias ..='cd ..'

# Hyprland env vars
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=Hyprland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland

# Starship prompt if installed
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

# Fish as default if available
if command -v fish &>/dev/null; then
    exec fish
fi
