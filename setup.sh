#!/usr/bin/env bash

# Dotfiles Setup Script
# Supports macOS and Linux (Ubuntu/Debian, Arch, Fedora)

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ -f /etc/debian_version ]]; then
        OS="debian"
    elif [[ -f /etc/arch-release ]]; then
        OS="arch"
    elif [[ -f /etc/fedora-release ]]; then
        OS="fedora"
    else
        print_error "Unsupported operating system"
        exit 1
    fi
    print_info "Detected OS: $OS"
}

# Install dependencies based on OS
install_dependencies() {
    print_info "Installing dependencies..."
    
    case $OS in
        macos)
            # Install Homebrew if not present
            if ! command -v brew &> /dev/null; then
                print_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            
            # Install from Brewfile if it exists
            if [[ -f "Brewfile" ]]; then
                print_info "Installing from Brewfile..."
                brew bundle
            else
                print_info "Installing individual packages..."
                brew install stow git tmux neovim zsh ripgrep fd bat fzf eza zoxide starship
                brew install --cask wezterm font-fira-code-nerd-font
            fi
            ;;
            
        debian)
            print_info "Updating package list..."
            sudo apt update
            
            print_info "Installing packages..."
            sudo apt install -y \
                stow git tmux neovim zsh curl wget \
                build-essential cmake python3-pip \
                ripgrep fd-find bat fzf \
                fonts-firacode fonts-noto-color-emoji
            
            # Install eza (not in standard repos)
            if ! command -v eza &> /dev/null; then
                print_info "Installing eza..."
                sudo apt install -y gpg
                sudo mkdir -p /etc/apt/keyrings
                wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
                echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
                sudo apt update
                sudo apt install -y eza
            fi
            
            # Install zoxide
            if ! command -v zoxide &> /dev/null; then
                print_info "Installing zoxide..."
                curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
            fi
            ;;
            
        arch)
            print_info "Updating package database..."
            sudo pacman -Sy
            
            print_info "Installing packages..."
            sudo pacman -S --noconfirm \
                stow git tmux neovim zsh curl wget \
                base-devel cmake python-pip \
                ripgrep fd bat fzf eza zoxide \
                ttf-fira-code noto-fonts-emoji
            ;;
            
        fedora)
            print_info "Installing packages..."
            sudo dnf install -y \
                stow git tmux neovim zsh curl wget \
                gcc gcc-c++ make cmake python3-pip \
                ripgrep fd-find bat fzf \
                fontconfig-enhanced-defaults \
                fira-code-fonts google-noto-emoji-fonts
            
            # Install eza
            if ! command -v eza &> /dev/null; then
                print_info "Installing eza..."
                sudo dnf install -y eza
            fi
            
            # Install zoxide
            if ! command -v zoxide &> /dev/null; then
                print_info "Installing zoxide..."
                curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
            fi
            ;;
    esac
    
    print_success "Dependencies installed"
}

# Install additional tools
install_additional_tools() {
    print_info "Installing additional tools..."
    
    # Install Powerlevel10k
    if [[ ! -d "$HOME/powerlevel10k" ]]; then
        print_info "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
    else
        print_info "Powerlevel10k already installed"
    fi
    
    # Install TPM (Tmux Plugin Manager)
    if [[ ! -d "$HOME/.config/tmux/plugins/tpm" ]]; then
        print_info "Installing Tmux Plugin Manager..."
        mkdir -p "$HOME/.config/tmux/plugins"
        git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
    else
        print_info "TPM already installed"
    fi
    
    # Install asdf
    if [[ ! -d "$HOME/.asdf" ]]; then
        print_info "Installing asdf version manager..."
        git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.13.1
    else
        print_info "asdf already installed"
    fi
    
    print_success "Additional tools installed"
}

# Create template files for secrets
create_template_files() {
    print_info "Creating template files for secrets..."
    
    # Create directories if they don't exist
    mkdir -p .config/zsh
    mkdir -p .config/wezterm
    
    # OpenAI token template
    if [[ ! -f ".config/zsh/openai_token.zsh.example" ]]; then
        cat > .config/zsh/openai_token.zsh.example << 'EOF'
# OpenAI API Token
# Uncomment and add your token
# export OPENAI_API_KEY="your-openai-api-key-here"
EOF
    fi
    
    # GitHub token template
    if [[ ! -f ".config/zsh/github_token.zsh.example" ]]; then
        cat > .config/zsh/github_token.zsh.example << 'EOF'
# GitHub Personal Access Token
# Uncomment and add your token
# export GITHUB_TOKEN="your-github-token-here"
EOF
    fi
    
    # GitHub MCP token template
    if [[ ! -f ".config/zsh/github_mcp_token.zsh.example" ]]; then
        cat > .config/zsh/github_mcp_token.zsh.example << 'EOF'
# GitHub MCP Token
# Uncomment and add your token
# export GITHUB_MCP_TOKEN="your-github-mcp-token-here"
EOF
    fi
    
    # Work aliases template
    if [[ ! -f ".config/zsh/work_aliases.zsh.example" ]]; then
        cat > .config/zsh/work_aliases.zsh.example << 'EOF'
# Work-specific aliases
# Add your work-related aliases here
# alias work-vpn='sudo openvpn /path/to/config.ovpn'
# alias work-ssh='ssh user@work-server.com'
EOF
    fi
    
    # Kubectl aliases template
    if [[ ! -f ".config/zsh/kubectl_aliases.zsh.example" ]]; then
        cat > .config/zsh/kubectl_aliases.zsh.example << 'EOF'
# Kubectl aliases
# alias k='kubectl'
# alias kgp='kubectl get pods'
# alias kgs='kubectl get svc'
# alias kgd='kubectl get deployment'
EOF
    fi
    
    # WezTerm SSH template
    if [[ ! -f ".config/wezterm/ssh.lua.example" ]]; then
        cat > .config/wezterm/ssh.lua.example << 'EOF'
-- SSH connection configurations for WezTerm
-- Example configuration:
return {
  -- {
  --   name = "My Server",
  --   host = "example.com",
  --   user = "myuser",
  --   port = 22,
  -- },
}
EOF
    fi
    
    print_success "Template files created"
}

# Setup stow symlinks
setup_stow() {
    print_info "Setting up symlinks with GNU Stow..."
    
    # Backup existing files
    backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    files_to_backup=(
        ".zshrc"
        ".zprofile"
        ".gitconfig"
        ".config/nvim"
        ".config/tmux"
        ".config/wezterm"
        ".config/zsh"
        ".config/git"
    )
    
    need_backup=false
    for file in "${files_to_backup[@]}"; do
        if [[ -e "$HOME/$file" && ! -L "$HOME/$file" ]]; then
            need_backup=true
            break
        fi
    done
    
    if [[ "$need_backup" == true ]]; then
        print_warning "Backing up existing files to $backup_dir"
        mkdir -p "$backup_dir"
        
        for file in "${files_to_backup[@]}"; do
            if [[ -e "$HOME/$file" && ! -L "$HOME/$file" ]]; then
                print_info "Backing up $file"
                mv "$HOME/$file" "$backup_dir/"
            fi
        done
    fi
    
    # Run stow
    print_info "Creating symlinks..."
    stow -v .
    
    print_success "Symlinks created"
}

# Set Zsh as default shell
set_default_shell() {
    if [[ "$SHELL" != *"zsh"* ]]; then
        print_info "Setting Zsh as default shell..."
        
        # Add zsh to /etc/shells if not present
        if ! grep -q "$(which zsh)" /etc/shells; then
            print_info "Adding zsh to /etc/shells..."
            echo "$(which zsh)" | sudo tee -a /etc/shells
        fi
        
        chsh -s "$(which zsh)"
        print_success "Zsh set as default shell. Please log out and back in for changes to take effect."
    else
        print_info "Zsh is already the default shell"
    fi
}

# Main setup function
main() {
    print_info "Starting dotfiles setup..."
    
    # Change to script directory
    cd "$(dirname "$0")"
    
    detect_os
    install_dependencies
    install_additional_tools
    create_template_files
    setup_stow
    set_default_shell
    
    print_success "Setup complete!"
    
    # Post-installation instructions
    echo
    print_info "Post-installation steps:"
    echo "1. Copy and edit the template files in .config/zsh/*.example"
    echo "2. Open a new terminal and run: p10k configure"
    echo "3. Open tmux and press Ctrl-a + I to install plugins"
    echo "4. Open Neovim and let plugins install automatically"
    echo "5. Configure git with your name and email:"
    echo "   git config --global user.name \"Your Name\""
    echo "   git config --global user.email \"your.email@example.com\""
    echo
    print_warning "Don't forget to restart your terminal or run: source ~/.zshrc"
}

# Run main function
main "$@"