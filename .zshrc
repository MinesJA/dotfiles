# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-23.jdk/Contents/Home"

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="$PATH:$JAVA_HOME/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="/usr/local/bin:$PATH"


# NOTE!!!
# Path must have /Users/jonathan.mines/bin: at the beggining
# workstation keeps trying to change this. Do not let it win
export PATH="$HOME/bin:$PATH"

#export PATH="$HOME/.local/share/nvim/mason/packages/solargraph/bin:$PATH"
# .profile
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.

# .bash_profile
#[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

#libpq is keg-only, which means it was not symlinked into /opt/homebrew,
#because conflicts with postgres formula.
#
#If you need to have libpq first in your PATH, run:
#  echo 'export PATH="/opt/homebrew/opt/libpq/bin:$PATH"' >> ~/.zshrc
#
#For compilers to find libpq you may need to set:
#  export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
#  export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"
#
#For pkg-config to find libpq you may need to set:
#  export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"

eval "$(fzf --zsh)"

# Initialize rbenv
eval "$(rbenv init -)"

if [ -e ~/dotfiles/.config/zsh/openai_token.zsh ]; then
  source ~/dotfiles/.config/zsh/openai_token.zsh
else
  echo "openai_token file does not exist"
fi

if [ -e ~/dotfiles/.config/zsh/github_token.zsh ]; then
  source ~/dotfiles/.config/zsh/github_token.zsh
else
  echo "github_token file does not exist"
fi

if [ -e ~/dotfiles/.config/zsh/github_mcp_token.zsh ]; then
  source ~/dotfiles/.config/zsh/github_mcp_token.zsh
else
  echo "github_mcp_token file does not exist"
fi

if [ -e ~/dotfiles/.config/zsh/work_aliases.zsh ]; then
    source ~/dotfiles/.config/zsh/work_aliases.zsh
else
  echo "work_aliases file does not exist"
fi

if [ -e ~/dotfiles/.config/zsh/kubectl_aliases.zsh ]; then
    source ~/dotfiles/.config/zsh/kubectl_aliases.zsh
else
  echo "kubectl_aliases file does not exist"
fi

source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/git_aliases.zsh

# Ruby project setup function
setup_ruby_project() {
    local ruby_version=$(cat .ruby-version 2>/dev/null)
    
    if [ -z "$ruby_version" ]; then
        echo "No .ruby-version file found"
        return 1
    fi
    
    echo "Installing Ruby $ruby_version..."
    rbenv install "$ruby_version" --skip-existing
    
    echo "Setting local Ruby version..."
    rbenv local "$ruby_version"
    
    echo "Installing ruby-lsp..."
    gem install ruby-lsp
    
    echo "Rehashing rbenv..."
    rbenv rehash
    
    echo "✅ Setup complete! Ruby $ruby_version with ruby-lsp is ready."
}




