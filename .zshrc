source $HOME/.local/share/common.sh

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Install plugins
source $HOME/.local/share/antigen/antigen.zsh
antigen bundle git
antigen bundle pip
antigen bundle command-not-found
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle tom-doerr/zsh_codex@main
antigen bundle conda-incubator/conda-zsh-completion
antigen theme romkatv/powerlevel10k
antigen apply

# Enable history
export HISTFILE=~/.local/.zsh_history
export SAVEHIST=100000
export KEYTIMEOUT=1 # Don't wait for multibound sequences
setopt EXTENDED_HISTORY # Record timestamp in history
setopt HIST_FIND_NO_DUPS # Remove duplicates from history search
setopt HIST_IGNORE_DUPS # Don't record an entry that was just recorded again.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate entry before the original entry.
setopt HIST_VERIFY # Don't execute immediately upon history expansion.
setopt INC_APPEND_HISTORY # Write to the history file immediately, not when the shell exits.

# Disable pause
stty -ixon 2>/dev/null

# Nice history search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Search files with fzf
bindkey '^f' fzf-file-widget
# Search hidden dirs as well
export FZF_CTRL_T_COMMAND='ag --hidden --silent --ignore .git -l -g ""'
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
# Preview commands to see multiple properly
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3
  --bind 'ctrl-/:toggle-preview'
  --color header:italic"
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="--preview 'lsd --tree {}'"

# Edit command in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# Jump to start of the line, ^A is used as tmux prefix, also ^B makes more sense, since 'beginning'
bindkey '^b' beginning-of-line

# Complete one word with end
bindkey '^[[4~' forward-word

# To customize prompt, run `p10k configure`
p10k_config_path="$HOME/.config/p10k/config.zsh"
[[ ! -f "$p10k_config_path" ]] || source "$p10k_config_path"

# AWS CLI completion
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/local/bin/aws_completer' aws

# disable autocd
unsetopt autocd

# AI Autocomplete
export ZSH_CUSTOM="$HOME/.local/share/zsh_custom"
export ZSH_CODEX_PYTHON="$HOME/miniconda3/bin/python"
source "$ZSH_CUSTOM/plugins/zsh_codex/zsh_codex.plugin.zsh"
bindkey ^X create_completion
# Allow comments in interactive shell
setopt interactivecomments
# Make comments visible
ZSH_HIGHLIGHT_STYLES[comment]='none'

# Active zoxide
eval "$(zoxide init --cmd cd zsh)"
