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

alias cc="claude"
alias ccb="claude --dangerously-skip-permissions"
alias ccc="claude --dangerously-skip-permissions --model haiku '/commit'"
function ccpr() {
	claude --dangerously-skip-permissions --model haiku "/pr $*"
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
