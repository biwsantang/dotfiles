# Bash functions

# Unlock keychain when running claude over SSH
claude() {
  if [ -n "$SSH_CONNECTION" ] && [ -z "$KEYCHAIN_UNLOCKED" ]; then
    security unlock-keychain ~/Library/Keychains/login.keychain-db
    export KEYCHAIN_UNLOCKED=true
  fi
  command claude "$@"
}

# Update repo name for starship prompt (only on directory change)
__update_repo_name() {
  [ "$__LAST_PWD" = "$PWD" ] && return
  __LAST_PWD="$PWD"
  if [ -e .git ]; then
    local d=$([ -f .git ] && awk '{print $2}' .git || echo .git)
    export __REPO_NAME=$(awk -F'[:/]' '/url = /{gsub(/\.git$/,""); print $(NF-1)"/"$NF; exit}' "${d%/worktrees/*}/config" 2>/dev/null)
  else
    export __REPO_NAME=""
  fi
}
PROMPT_COMMAND="__update_repo_name${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
__update_repo_name  # Initialize on shell start

function ccc() {
    claude --dangerously-skip-permissions "use commit skill to commit $*"
}

# Claude PR function - commits then creates PR
function ccpr() {
    claude --dangerously-skip-permissions "use commit and pr skills to run commit if have any and then run pr $*"
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

# Navigate to git repositories in ~/developer and open dev environment
# No wrapper needed - ~/.local/bin/dev is in PATH
