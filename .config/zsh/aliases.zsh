alias zso="source ~/.zshrc"
alias znv="nvim ~/dotfiles/.zshrc"
alias conf="nvim ~/dotfiles"

# Open images with feh (Linux)
alias open="feh"

# VPN connection script
alias nvpn="sudo ~/vpn-connect.sh"

# Python virtual environment activation
alias venv="[ -f venv/bin/activate ] && source venv/bin/activate || [ -f .venv/bin/activate ] && source .venv/bin/activate || echo 'No virtual environment found (venv/ or .venv/)'"

# Reset keyboard rate
alias resetkeys="xset r rate 250 50"
