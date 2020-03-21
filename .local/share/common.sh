# Increase history size
HISTSIZE=10000
HISTFILESIZE=100000

# More info
alias  lh='ls -alh'

# Shortcut for quick conda activation
conda_deactivate () {
	while [ -n "$CONDA_DEFAULT_ENV" ]; do
		conda deactivate
	done
}
alias act='conda_deactivate; conda activate "$(basename "$(pwd)")"'

# Prevent vim from trying to access X, improves vim inside tmux startup time, but disables clipboard
alias vim='vim -X'

# More consice man pages
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

# Disable pause
stty -ixon

# Function to install required programs
install_standard() {
	sudo add-apt-repository ppa:mmstick76/alacritty -n -y
	sudo add-apt-repository ppa:regolith-linux/release -n -y
	sudo apt-get update
	xargs sudo apt-get install -y < $HOME/.local/share/apt_install.txt

	if [ ! -d "$HOME/miniconda3" ]; then
		wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O "$HOME/miniconda3.sh"
		bash "$HOME/miniconda3.sh" -b -p "$HOME/miniconda3"
		rm "$HOME/miniconda3.sh"
	else
		echo "Miniconda installation found"
	fi

	if command -v pip > /dev/null; then
		pip install -r $HOME/.local/share/pip_install.txt
	fi
}
