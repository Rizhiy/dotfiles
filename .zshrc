# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Install plugins
source $HOME/.local/share/antigen/antigen.zsh
antigen bundle git
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme romkatv/powerlevel10k
antigen apply

# Enable history
export HISTFILE=~/.local/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
setopt EXTENDED_HISTORY # Record timestamp in history
setopt HIST_FIND_NO_DUPS # Remove duplicates from history search
setopt HIST_IGNORE_DUPS # Don't record an entry that was just recorded again.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate entry before the original entry.
setopt HIST_VERIFY # Don't execute immediately upon history expansion.
setopt INC_APPEND_HISTORY # Write to the history file immediately, not when the shell exits.

# Disable pause
stty -ixon 2>/dev/null

source $HOME/.local/share/common.sh

# calculator
calc() {
    python -c 'from math import *; import sys; print(eval(" ".join(sys.argv[1:])))' "$@"
}

# Nice history search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Search files with fzf
bindkey '^F' fzf-file-widget
# Search hidden dirs as well
export FZF_CTRL_T_COMMAND='ag --hidden --silent --ignore .git -l -g ""'

# Edit command in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Jump to start of the line, ^A is used as tmux prefix, also ^B makes more sense, since 'beginning'
bindkey '^B' beginning-of-line

# Only complete on tab, without expanding
bindkey '^I' complete-word

# Complete one word with end
bindkey '^[[4~' forward-word

# To customize prompt, run `p10k configure`
p10k_config_path="$HOME/.config/p10k/config.zsh"
[[ ! -f "$p10k_config_path" ]] || source "$p10k_config_path"

# AWS CLI completion
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/local/bin/aws_completer' aws

# Extra paths
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
