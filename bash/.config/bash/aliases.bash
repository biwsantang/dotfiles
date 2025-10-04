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

# Jira alias for current user's issues in open sprints
jira_cu() {
    if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
        jira issue list "$@"
    else
        jira issue list -q"sprint IN openSprints() and assignee = currentUser()" "$@"
    fi
}
alias jira\ cu="jira_cu"

# SSH with compatible terminal when needed
alias sshc="TERM=xterm-256color command ssh"

# Keychain management
alias unlock-keychain="security unlock-keychain ~/Library/Keychains/login.keychain-db"