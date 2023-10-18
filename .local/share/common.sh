# Increase history size
export HISTSIZE=10000
export HISTFILESIZE=100000
export SAVEHIST=$HISTSIZE
export KEYTIMEOUT=1

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

if [ -d "$HOME/miniconda3" ]; then
    condadir="$HOME/miniconda3"
elif [ -d "$HOME/anaconda3" ]; then
    condadir="$HOME/anaconda3"
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$condadir/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$condadir/etc/profile.d/conda.sh" ]; then
        . "$condadir/etc/profile.d/conda.sh"
    else
        export PATH="$condadir/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Add cuda to path
export PATH=/usr/local/cuda/bin:/usr/local/cuda/NsightCompute-2019.1${PATH:+:${PATH}}

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

# Add user bin to PATH
export PATH="$HOME/.bin:$PATH"

conda activate

# set python debugger
export PYTHONBREAKPOINT=pudb.set_trace

# Set editor
export EDITOR="$HOME/.bin/nvim.appimage"

# Add Go to path
export PATH="$PATH:/usr/local/go/bin"
export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Add cargo to path
export PATH="$PATH:/root/.cargo/bin"
