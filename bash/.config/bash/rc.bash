#!/usr/bin/env bash

# Starship prompt
eval "$(starship init bash)"

# CodeEdit shell integration
if [ "$TERM_PROGRAM" = "CodeEditApp_Terminal" ]; then
    [ -f "/Applications/CodeEdit.app/Contents/Resources/codeedit_shell_integration.bash" ] && \
        source "/Applications/CodeEdit.app/Contents/Resources/codeedit_shell_integration.bash" 2>/dev/null
fi

# Forgit plugin (if available)
[ -f "$HOMEBREW_PREFIX/share/forgit/forgit.plugin.bash" ] && \
    source "$HOMEBREW_PREFIX/share/forgit/forgit.plugin.bash"

# Key bindings (requires bash 4+)
if [ "${BASH_VERSINFO[0]}" -ge 4 ]; then
    bind -x '"\C-e": edit_command_line'
fi

# Enable bash completion
if [ -f "$HOMEBREW_PREFIX/etc/bash_completion" ]; then
    source "$HOMEBREW_PREFIX/etc/bash_completion"
fi

# Check if zellij is available and launch it
if command -v zellij &>/dev/null && [ -z "$ZELLIJ" ]; then
    # Launch zellij
    eval "$(zellij setup --generate-auto-start bash)"
fi