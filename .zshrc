# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ $(uname) == "Darwin" ]]; then
  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

  export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

  export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-23.jdk/Contents/Home"
  export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
  export PATH="$PATH:$JAVA_HOME/bin"
  export PATH="$PATH:$HOME/go/bin"
  export PATH="/usr/local/bin:$PATH"

  # NOTE!!!
  # Path must have /Users/jonathan.mines/bin: at the beggining
  # workstation keeps trying to change this. Do not let it win
  export PATH="$HOME/bin:$PATH"

  # Initialize rbenv
  eval "$(rbenv init -)"

elif [[ $(uname) == "Linux" ]]; then
  source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
  export PATH="/home/jonathanmines/.local/bin/:$PATH"
  export PATH="/home/jonathanmines/.pyenv/bin/:$PATH"
  export FrameworkPathOverride=/lib/mono/4.7.1-api/

else
  echo 'Unknown OS!'
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(fzf --zsh)"

# Load secret files for macOS
if [[ $(uname) == "Darwin" ]]; then
  if [ -e ~/dotfiles/.config/zsh/tokens.zsh ]; then
    source ~/dotfiles/.config/zsh/tokens.zsh
  fi

  if [ -e ~/dotfiles/.config/zsh/work_aliases.zsh ]; then
      source ~/dotfiles/.config/zsh/work_aliases.zsh
  fi

  if [ -e ~/dotfiles/.config/zsh/kubectl_aliases.zsh ]; then
      source ~/dotfiles/.config/zsh/kubectl_aliases.zsh
  fi
fi

# Load common aliases
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/git_aliases.zsh

# Load work-specific aliases if available (Linux)
if [[ $(uname) == "Linux" ]]; then
  if [ -f ~/.config/zsh/work_aliases ]; then
      source ~/.config/zsh/work_aliases
  fi

  if [ -f ~/.config/zsh/kubectl_aliases.zsh ]; then
      source ~/.config/zsh/kubectl_aliases.zsh
  fi

  # Load secrets and environment variables (not tracked in git)
  if [ -f ~/.config/zsh/secrets.zsh ]; then
      source ~/.config/zsh/secrets.zsh
  fi
fi

alias claude=/usr/local/bin/claude

# Ruby project setup function (macOS)
if [[ $(uname) == "Darwin" ]]; then
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
fi

#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
