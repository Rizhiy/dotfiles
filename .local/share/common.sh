# Increase history size
HISTSIZE=10000
HISTFILESIZE=100000

# More info
alias  lh='ls -alh'

# Exit ranger in current dir
alias ranger='ranger --choosedir=$HOME/rangerdir; LASTDIR=`cat $HOME/rangerdir`; cd "$LASTDIR"'
# Shortcut for quick conda activation
conda_deactivate () {
	while [ -n "$CONDA_DEFAULT_ENV" ]; do
		conda deactivate
	done
}
alias act='conda_deactivate; conda activate "$(basename "$(pwd)")"'

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
