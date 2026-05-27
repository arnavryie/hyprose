# ~/.bashrc — Hyprose default shell config

[[ $- != *i* ]] && return

# ── Aliases ────────────────────────────────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first'
alias lt='eza --tree --icons --level=2'
alias cat='bat --style=plain'
alias grep='grep --color=auto'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias mkdir='mkdir -pv'
alias df='df -hT'
alias free='free -mh'
alias ip='ip -color=auto'
alias vi='nvim'
alias vim='nvim'

# ── History ────────────────────────────────────────────────────────────────
HISTCONTROL=ignoredups:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend

# ── Starship prompt ────────────────────────────────────────────────────────
eval "$(starship init bash)"

# ── FZF ────────────────────────────────────────────────────────────────────
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

# ── Fastfetch on login ─────────────────────────────────────────────────────
if [[ $(tty) == /dev/tty* ]]; then
    fastfetch
fi
