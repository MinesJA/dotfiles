# Dotfiles

My personal dotfiles for macOS and Linux, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Contents

- **Neovim** - Modern Vim configuration with LSP support
- **Tmux** - Terminal multiplexer configuration with custom keybindings
- **Zsh** - Shell configuration with Powerlevel10k theme
- **WezTerm** - GPU-accelerated terminal emulator configuration
- **Git** - Global git configuration (symlinked from dotfiles)
- **Scripts** - Various utility scripts

## Prerequisites

### macOS
```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Xcode Command Line Tools
xcode-select --install
```

### Linux
Most dependencies can be installed via your distribution's package manager.

## Quick Setup

### Automated Installation (Recommended)

```bash
# Clone the repository
git clone <repository-url> ~/dotfiles
cd ~/dotfiles

# Run the setup script
./setup.sh
```

The setup script will:
- Detect your operating system
- Install all required dependencies
- Set up symlinks using GNU Stow
- Create template files for secrets
- Install additional tools (TPM for tmux, etc.)

### Manual Installation

1. **Install Dependencies**

   **macOS (using Homebrew):**
   ```bash
   cd ~/dotfiles
   brew bundle  # Installs everything from Brewfile
   ```

   **Ubuntu/Debian:**
   ```bash
   sudo apt update
   sudo apt install -y \
     stow git tmux neovim zsh curl wget \
     build-essential cmake python3-pip \
     ripgrep fd-find bat fzf \
     fonts-firacode fonts-noto-color-emoji
   ```

   **Arch Linux:**
   ```bash
   sudo pacman -S \
     stow git tmux neovim zsh curl wget \
     base-devel cmake python-pip \
     ripgrep fd bat fzf \
     ttf-fira-code noto-fonts-emoji
   ```

2. **Clone and Stow Dotfiles**
   ```bash
   git clone <repository-url> ~/dotfiles
   cd ~/dotfiles
   
   # Create symlinks for all configurations
   stow .
   
   # Or stow individual configurations
   stow -t ~ .config/nvim
   stow -t ~ .config/tmux
   # etc...
   ```

3. **Set Zsh as Default Shell**
   ```bash
   chsh -s $(which zsh)
   ```

4. **Install Powerlevel10k**
   ```bash
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
   ```

5. **Install Tmux Plugin Manager**
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```

6. **Create Secret Files**
   ```bash
   # Copy templates and fill in your values
   cp .config/zsh/tokens.zsh.example .config/zsh/tokens.zsh
   cp .config/wezterm/ssh.lua.example .config/wezterm/ssh.lua
   ```

## Dependencies

### Core Tools
- **GNU Stow** - Symlink manager
- **Git** - Version control
- **Zsh** - Shell
- **Neovim** (>= 0.9) - Text editor
- **Tmux** - Terminal multiplexer
- **WezTerm** - Terminal emulator (optional, but recommended)

### Command Line Tools
- **ripgrep** (rg) - Fast text search
- **fd** - Fast file search
- **bat** - Better cat with syntax highlighting
- **fzf** - Fuzzy finder
- **eza** - Modern ls replacement
- **zoxide** - Smarter cd command
- **starship** or **powerlevel10k** - Shell prompt

### Development Tools
- **asdf** - Version manager for multiple languages
- **Python 3** with pip
- **Node.js** and npm
- **Go**
- **Rust** (for some Neovim plugins)

### Fonts
- **FiraCode Nerd Font** or **JetBrains Mono Nerd Font**
- **Noto Color Emoji** (for emoji support)

## Configuration Details

### Neovim
- Package manager: [lazy.nvim](https://github.com/folke/lazy.nvim)
- LSP support for multiple languages
- Custom keybindings in `lua/jonathanmines/remap.lua`
- Theme: Configured in `lua/jonathanmines/lazy/colors.lua`

### Tmux
- Prefix key: `Ctrl-a`
- Plugin manager: [TPM](https://github.com/tmux-plugins/tpm)
- Install plugins: `prefix + I`
- Custom status bar configuration

### Zsh
- Theme: Powerlevel10k
- Custom aliases in `.config/zsh/aliases.zsh`
- Secret tokens consolidated in `tokens.zsh` (not tracked by git)

### WezTerm
- GPU-accelerated terminal
- Custom color scheme and font configuration
- SSH connection configs in `ssh.lua`

## Post-Installation

1. **Configure Powerlevel10k**
   ```bash
   p10k configure
   ```

2. **Install Tmux Plugins**
   - Open tmux
   - Press `prefix + I` (Ctrl-a, then I)

3. **Install Neovim Plugins**
   - Open Neovim
   - Plugins will auto-install via lazy.nvim

4. **Set up Language Servers**
   ```bash
   # In Neovim, use :Mason to install language servers
   :Mason
   ```

5. **Configure Git**
   The `.gitconfig` file is automatically symlinked from dotfiles. Update the user information:
   ```bash
   # Edit the dotfiles .gitconfig directly
   vim ~/dotfiles/.gitconfig
   
   # Or use git config commands (which will modify the symlinked file)
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

## Updating

To update your dotfiles:
```bash
cd ~/dotfiles
git pull
stow -R .  # Restow to update symlinks
```

## Troubleshooting

### Stow Conflicts
If stow reports conflicts:
```bash
# See what would be stowed
stow -n -v .

# Force restow (careful, this will override existing files)
stow --adopt .
```

### Missing Commands
If commands are not found after installation:
- Ensure your PATH includes necessary directories
- Restart your shell or run `source ~/.zshrc`

### Font Issues
- Make sure to install a Nerd Font
- Set your terminal emulator to use the installed Nerd Font

### Neovim Issues
- Run `:checkhealth` in Neovim to diagnose issues
- Ensure you have the latest version of Neovim (>= 0.9)

## Video Tutorials

### Tmux
[Video Tutorial](https://www.youtube.com/watch?v=DzNmUNvnB04&ab_channel=DreamsofCode)

Using TPM - Tmux Plugin Manager
[Git Repo](https://github.com/tmux-plugins/tpm)

Need to clone it before being able to install plugins (see readme).

Then `prefix + I` to install in a Tmux session

### P10K (Arch Linux)
Followed [this guide](https://davidtsadler.com/posts/arch/2020-09-07/installing-zsh-and-powerlevel10k-on-arch-linux/)

## How to ignore files with Stow
See: `.stow-local-ignore`

## License

Feel free to use and modify these dotfiles as you see fit.