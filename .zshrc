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

export PATH="$PATH:$HOME/go/bin"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH=/Users/jonathan.mines/bin:$PATH
export PATH="$PATH:$HOME/.rvm/bin"

export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-11.jdk"
eval "$(fzf --zsh)"

if [ -e ~/dotfiles/.config/zsh/github_token.zsh ]; then
  source ~/dotfiles/.config/zsh/github_token.zsh
else
  echo "github_token file does not exist"
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




