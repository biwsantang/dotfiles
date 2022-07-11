export ZPLUG_HOME=/usr/local/opt/zplug
export PATH="/usr/local/opt/openjdk/bin:$PATH"
#source $ZPLUG_HOME/init.zsh

eval "$(starship init zsh)"
eval "$(pyenv init --path)"

export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

#zplug load
