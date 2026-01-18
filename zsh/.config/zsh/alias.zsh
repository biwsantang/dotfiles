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
	claude --dangerously-skip-permissions "/commit $*"
}
function ccpr() {
	claude --dangerously-skip-permissions "run /commit if have any and then run /pr $*"
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
