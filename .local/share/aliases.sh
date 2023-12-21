# lsd
alias ls='lsd'
alias lh='lsd -Al'
alias tree='lsd --tree'

# Shortcut for quick conda activation
conda_deactivate () {
	while [ -n "$CONDA_DEFAULT_ENV" ]; do
		conda deactivate
	done
}
alias get-env-name='echo "$(basename "$(pwd)")"'
alias de-act='conda_deactivate'
alias new-env='conda create -n "$(get-env-name)" python=3.11 -y'
act () {
	de-act
	env_name="$(get-env-name)"
	conda activate "$env_name" || new-env && conda activate "$env_name"
}
alias act-base='de-act; conda activate base'
alias rm-env='de-act; conda uninstall -n "$(get-env-name)" --all; act-base'

# Open project in tmux window
alias op='$HOME/.bin/open_project.sh'

# More concise man pages
cheat() {
    curl cheat.sh/"$1"
}
# dotfiles bare repository
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Alias for nvim
alias nvim='$HOME/.bin/nvim.appimage'

# Alias vim to nvim
alias vim="nvim"

# Make docker always execute as root
alias docker="sudo docker"

# easier tmux attach
alias a="tmux a"

# Always use conda ranger
alias ranger=$HOME/miniconda3/bin/ranger

# Load dotenv
alias load_dotenv=". dotenv.sh"

# Extra paths
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

# Git stuff
alias gs="git status"
alias gd="git diff"
alias gc="git commit -m"
alias gp="git pull"
