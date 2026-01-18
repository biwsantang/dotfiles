# Bash functions

# Unlock keychain when running claude over SSH
claude() {
  if [ -n "$SSH_CONNECTION" ] && [ -z "$KEYCHAIN_UNLOCKED" ]; then
    security unlock-keychain ~/Library/Keychains/login.keychain-db
    export KEYCHAIN_UNLOCKED=true
  fi
  command claude "$@"
}

# Use floating pane in zellij, regular command otherwise
function ccc() {
    if [ -n "$ZELLIJ" ]; then
        zellij action new-pane --floating --close-on-exit -- claude --dangerously-skip-permissions "/commit $*"
    else
        claude --dangerously-skip-permissions "/commit $*"
    fi
}

# Claude PR function - commits then creates PR
function ccpr() {
    if [ -n "$ZELLIJ" ]; then
        zellij action new-pane --floating --close-on-exit -- claude --dangerously-skip-permissions "run /commit if have any and then run /pr $*"
    else
        claude --dangerously-skip-permissions "run /commit if have any and then run /pr $*"
    fi
}

# Install Ghostty terminfo on remote server
# Usage: install-ghostty-on user@hostname
function install-ghostty-on() {
    infocmp -x xterm-ghostty | ssh "$1" -- tic -x -
}

# History search function using fzf
function hs() {
    local selected=$(history | tail -100 | fzf --tac --no-sort | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//')
    if [ -n "$selected" ]; then
        READLINE_LINE="$selected"
        READLINE_POINT=${#selected}
    fi
}

# Tmux session function
function t() {
    local session_name="${1:-0}"
    if [ -n "$1" ]; then
        session_name="X"
    fi
    tmux new-session -A -s "$session_name"
}

# Edit command line in editor (Ctrl-e)
function edit_command_line() {
    local tmpfile=$(mktemp)
    echo "$READLINE_LINE" > "$tmpfile"
    "$EDITOR" "$tmpfile"
    if [ -s "$tmpfile" ]; then
        READLINE_LINE=$(cat "$tmpfile")
        READLINE_POINT=${#READLINE_LINE}
    fi
    rm -f "$tmpfile"
}

# Navigate to git repositories in ~/developer
dev() {
  local dir
  dir=$(fd -H -t d '^\.git$' ~/developer --exec dirname | \
    fzf --preview '
      echo "󰘬 $(git -C {} branch --show-current)"
      echo ""
      echo "Recent commits:"
      git -C {} log --oneline -5
      echo ""
      echo "Status:"
      git -C {} status -s
      echo ""
      echo "Remotes:"
      git -C {} remote -v | head -2
    ' --preview-window=right:60%)
  [[ -n "$dir" ]] && cd "$dir"
}
