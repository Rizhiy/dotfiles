# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set fzf installation directory path
export FZF_BASE=$HOME/.local/share/fzf

# Path to your oh-my-zsh installation.
export ZSH=/home/rizhiy/.oh-my-zsh


# Install plugins
source $HOME/.local/share/antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundle git
antigen bundle fzf
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme romkatv/powerlevel10k
antigen apply

plugins=(
  fzf
  z
  vi-mode
  zsh_reload
  web-search
)

source $ZSH/oh-my-zsh.sh


# Remove shared history
unsetopt share_history

# Remove duplicates from history
setopt HIST_FIND_NO_DUPS

# Disable pause
stty -ixon 2>/dev/null

source $HOME/.local/share/common.sh

# calculator
calc() {
    python -c 'from math import *; import sys; print(eval(" ".join(sys.argv[1:])))' "$@"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Edit command in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line Edit command in line

# To customize prompt, run `p10k configure`
p10k_config_path="$HOME/.config/p10k/config.zsh"
[[ ! -f "$p10k_config_path" ]] || source "$p10k_config_path"
