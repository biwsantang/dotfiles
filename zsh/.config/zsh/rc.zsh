autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
