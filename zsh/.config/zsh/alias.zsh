alias c="clear"

alias ls="exa"
alias ll="ls -lahF"

alias cat="bat"

alias mkdir="mkdir -p"
alias cp="cp -r"

alias vim="nvim"

function fh() {
	print -z $( ([ -n "$ZSH_NAME" ] && history -100) | fzf --tac --no-sort | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

function t() {
	X=$#
	[[ $X -eq 0 ]] || X=X
	tmux new-session -A -s $X
}
