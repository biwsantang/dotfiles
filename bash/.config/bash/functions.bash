#!/usr/bin/env bash

# Use floating pane in zellij, regular command otherwise
ccc() {
    if [ -n "$ZELLIJ" ]; then
        zellij action new-pane --floating --close-on-exit -- claude --dangerously-skip-permissions '/commit'
    else
        claude --dangerously-skip-permissions '/commit'
    fi
}

# Claude PR function
ccpr() {
    if [ -n "$ZELLIJ" ]; then
        zellij action new-pane --floating --close-on-exit -- claude --dangerously-skip-permissions "/pr $*"
    else
        claude --dangerously-skip-permissions "/pr $*"
    fi
}

# Install Ghostty terminfo on remote server
# Usage: install-ghostty-on user@hostname
install-ghostty-on() {
    infocmp -x xterm-ghostty | ssh "$1" -- tic -x -
}

# History search function using fzf
hs() {
    local selected=$(history | tail -100 | fzf --tac --no-sort | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//')
    if [ -n "$selected" ]; then
        READLINE_LINE="$selected"
        READLINE_POINT=${#selected}
    fi
}

# Tmux session function
t() {
    local session_name="${1:-0}"
    if [ -n "$1" ]; then
        session_name="X"
    fi
    tmux new-session -A -s "$session_name"
}

# Edit command line in editor (Ctrl-e)
edit_command_line() {
    local tmpfile=$(mktemp)
    echo "$READLINE_LINE" > "$tmpfile"
    "$EDITOR" "$tmpfile"
    if [ -s "$tmpfile" ]; then
        READLINE_LINE=$(cat "$tmpfile")
        READLINE_POINT=${#READLINE_LINE}
    fi
    rm -f "$tmpfile"
}