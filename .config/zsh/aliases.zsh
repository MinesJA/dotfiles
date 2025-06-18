alias zso="source ~/.zshrc"
alias znv="nvim ~/dotfiles/.zshrc"
alias conf="nvim ~/dotfiles"
alias claude="$HOME/.claude/local/claude"

# I don't remember what this does...
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# Open images with feh
alias open="feh"

# VPN connection script
alias nvpn="sudo ~/vpn-connect.sh"

# Python virtual environment activation
alias venv="[ -f venv/bin/activate ] && source venv/bin/activate || [ -f .venv/bin/activate ] && source .venv/bin/activate || echo 'No virtual environment found (venv/ or .venv/)'"


alias resetkeys="xset r rate 250 50"
