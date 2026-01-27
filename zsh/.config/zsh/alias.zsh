alias c="clear"

alias ls="eza"
alias ll="ls -lahF"

export BAT_THEME="ansi"
# alias cat="batcat"
alias cat="bat"

alias mkdir="mkdir -p"
alias cp="cp -r"

#alias nvim="tmux_nvim"

alias cb="cd .."
alias ch="cd ~"
alias cg='cd $(git rev-parse --show-toplevel)'

# Jira alias for current user's issues in open sprints
jira_cu() {
    if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
        jira issue list "$@"
    else
        jira issue list -q"sprint IN openSprints() and assignee = currentUser()" "$@"
    fi
}
alias jira\ cu="jira_cu"

# Unlock keychain when running claude over SSH
claude() {
  if [ -n "$SSH_CONNECTION" ] && [ -z "$KEYCHAIN_UNLOCKED" ]; then
    security unlock-keychain ~/Library/Keychains/login.keychain-db
    export KEYCHAIN_UNLOCKED=true
  fi
  command claude "$@"
}

alias cc="claude"
alias ccb="claude --dangerously-skip-permissions"
function ccc() {
	claude --dangerously-skip-permissions "use commit skill to commit $*"
}
function ccpr() {
	claude --dangerously-skip-permissions "use commit and pr skills to run commit if have any and then run pr $*"
}

function hs() {
	print -z $( ([ -n "$ZSH_NAME" ] && history -100) | fzf --tac --no-sort | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

function t() {
	X=$#
	[[ $X -eq 0 ]] || X=X
	tmux new-session -A -s $X
}

#function tmux_nvim() {
#    if [[ -n $TMUX ]]; then
#        tmux new-window -c "${PWD}" "command nvim $@"
#    else
#        command nvim $@
#    fi
# }

export EDITOR="/opt/homebrew/bin/nvim"
export VISUAL="/opt/homebrew/bin/nvim"

# Update repo name for starship prompt on directory change
__update_repo_name() {
  if [ -e .git ]; then
    local d=$([ -f .git ] && awk '{print $2}' .git || echo .git)
    export __REPO_NAME=$(awk -F'[:/]' '/url = /{gsub(/\.git$/,""); print $(NF-1)"/"$NF; exit}' "${d%/worktrees/*}/config" 2>/dev/null)
  else
    export __REPO_NAME=""
  fi
}
chpwd() { __update_repo_name; }
__update_repo_name  # Initialize on shell start

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
