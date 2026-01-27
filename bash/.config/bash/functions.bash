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
dev() {
  if [[ "$1" == "." ]]; then
    if [[ -n "$ZELLIJ" ]]; then
      zellij action new-tab --layout dev
    else
      zellij --layout dev
    fi
    return
  fi
  local dirs
  dirs=$(fd -H '^\.git$' ~/developer --exec dirname | \
    while read p; do echo "${p#$HOME/developer/}	$p"; done | \
    fzf -m --delimiter='\t' --with-nth=1 --preview '
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
  [[ -z "$dirs" ]] && return
  local first_dir panes_kdl add_dirs
  first_dir=$(echo "$dirs" | head -1)
  panes_kdl=""
  add_dirs=""
  while IFS= read -r d; do
    panes_kdl+="                    pane cwd=\"$d\""$'\n'
    [[ "$d" != "$first_dir" ]] && add_dirs+=" \"--add-dir\" \"$d\""
  done <<< "$dirs"
  local layout_file="/tmp/zellij-dev-$$.kdl"
  cat > "$layout_file" <<EOF
layout {
    tab focus=true {
        pane split_direction="vertical" {
            pane size="33%" cwd="$first_dir" command="lazygit"
            pane size="67%" split_direction="horizontal" {
                pane size="67%" focus=true cwd="$first_dir" command="claude" {
                    args "--dangerously-skip-permissions"$add_dirs
                }
                pane size="33%" stacked=true expanded=false {
$panes_kdl                }
            }
        }
    }
}
EOF
  cd "$first_dir"
  if [[ -n "$ZELLIJ" ]]; then
    zellij action new-tab --layout "$layout_file"
  else
    zellij --layout "$layout_file"
  fi
  rm -f "$layout_file"
}
