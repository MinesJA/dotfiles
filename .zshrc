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

# Added by workstation/bin/install_workstation.sh
export PATH=/Users/jonathan.mines/bin:$PATH

export PATH="$PATH:$HOME/.rvm/bin"

export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-11.jdk"
eval "$(fzf --zsh)"

if [ -f ~/.config/zsh/github_token ]; then
    source ~/.config/zsh/github_token
else
  echo "ERROR: GITHUB_TOKEN env variable not configured"
fi

source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/git_aliases.zsh

if [ -f ~/.config/zsh/work_aliases ]; then
    source ~/.config/zsh/work_aliases
fi

if [ -f ~/.config/zsh/kubectl_aliases ]; then
    source ~/.config/zsh/kubectl_aliases
fi





