# SSH with compatible terminal when needed
alias sshc="TERM=xterm-256color ssh"

# Install Ghostty terminfo on remote server
# Usage: install-ghostty-on user@hostname
install-ghostty-on() {
    infocmp -x xterm-ghostty | ssh "$1" -- tic -x -
}

# Keychain management
alias unlock-keychain="security unlock-keychain ~/Library/Keychains/login.keychain-db"
