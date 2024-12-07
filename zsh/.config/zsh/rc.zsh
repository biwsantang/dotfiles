autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -i
_comp_options+=(globdots)

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

[ -f $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh ] && source $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh