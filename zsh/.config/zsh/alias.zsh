alias c="clear"

alias ls="eza"
alias ll="ls -lahF"

alias cat="bat"

alias mkdir="mkdir -p"
alias cp="cp -r"

alias nvim="tmux_nvim"

alias cb="cd .."
alias ch="cd ~"

function hs() {
	print -z $( ([ -n "$ZSH_NAME" ] && history -100) | fzf --tac --no-sort | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

function t() {
	X=$#
	[[ $X -eq 0 ]] || X=X
	tmux new-session -A -s $X
}

function tmux_nvim() {
    if [[ -n $TMUX ]]; then
        tmux new-window -c "${PWD}" "command nvim $@"
    else
        command nvim $@
    fi
}