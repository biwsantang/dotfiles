#!/usr/bin/env bash

# Source .fishprofile shell environment variables (if exists)
[ -f "$HOME/.fishprofile" ] && source "$HOME/.fishprofile"

# Path configuration
export PATH="$PATH:/Users/biwsantang/.cache/lm-studio/bin"
export PATH="/Users/biwsantang/.bun/bin:$PATH"
export PATH="$PATH:/Users/biwsantang/.local/bin"

# Editor configuration
export EDITOR="/opt/homebrew/bin/nvim"
export VISUAL="/opt/homebrew/bin/nvim"

# Bat theme
export BAT_THEME="ansi"

# Starship prompt configuration
export STARSHIP_CONFIG=~/.config/starship/lookgood.toml