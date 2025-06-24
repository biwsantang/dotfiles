# Only rebuild completion cache once per day
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  [[ -n "$ZSH_DISABLE_COMPFIX" ]] && compinit -u || compinit
else
  [[ -n "$ZSH_DISABLE_COMPFIX" ]] && compinit -C -u || compinit -C
fi
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

[ -f $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh ] && source $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh
