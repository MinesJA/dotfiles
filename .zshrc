# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ $(uname) == "Darwin" ]]; then
  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

elif [[ $(uname) == "Linux" ]]; then
  source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

else
  echo 'Unknown OS!'
fi

export PATH="/home/jonathanmines/.local/bin/:$PATH"
export PATH="/home/jonathanmines/.pyenv/bin/:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Environment variables moved to ~/.config/zsh/secrets.zsh for security

export FrameworkPathOverride=/lib/mono/4.7.1-api/
eval "$(fzf --zsh)"

source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/kubectl_aliases.zsh
source ~/.config/zsh/git_aliases.zsh

# Load work-specific aliases if available
if [ -f ~/.config/zsh/work_aliases ]; then
    source ~/.config/zsh/work_aliases
fi

# Load secrets and environment variables (not tracked in git)
if [ -f ~/.config/zsh/secrets.zsh ]; then
    source ~/.config/zsh/secrets.zsh
fi

#alias dockstart=sudo systemctl start docker

