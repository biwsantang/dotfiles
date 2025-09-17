# Bash aliases
alias c="clear"
alias ls="eza"
alias ll="ls -lahF"
alias cat="bat"
alias mkdir="mkdir -p"
alias cp="cp -r"
alias cb="cd .."
alias ch="cd ~"
alias cg='cd $(git rev-parse --show-toplevel)'
alias cc="claude"
alias ccb="claude --dangerously-skip-permissions"

# SSH with compatible terminal when needed
alias sshc="TERM=xterm-256color command ssh"