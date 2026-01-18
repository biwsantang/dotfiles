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

# Navigate to git repositories in ~/developer and open dev environment
dev() {
  local dir
  dir=$(fd -H '^\.git$' ~/developer --exec dirname | \
    while read p; do echo "${p#$HOME/developer/}	$p"; done | \
    fzf --delimiter='\t' --with-nth=1 --preview '
      path=$(echo {} | cut -f2)
      echo "󰘬 $(git -C "$path" branch --show-current)"
      echo ""
      echo "Recent commits:"
      git -C "$path" log --oneline -5
      echo ""
      echo "Status:"
      git -C "$path" status -s
      echo ""
      echo "Remotes:"
      git -C "$path" remote -v | head -2
    ' --preview-window=right:60% | cut -f2)
  [[ -n "$dir" ]] && cd "$dir" && zellij --layout dev
}
