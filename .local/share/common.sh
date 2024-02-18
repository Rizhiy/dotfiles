# Increase history size
export HISTSIZE=10000
export HISTFILESIZE=100000
export SAVEHIST=$HISTSIZE
export KEYTIMEOUT=1

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

conda activate

# Add user bin to PATH
export PATH="$HOME/.bin:$PATH"

# Add .local/bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# set python debugger
export PYTHONBREAKPOINT=pudb.set_trace

# Set editor
export EDITOR=nvim

# Add Go to path
export PATH="$PATH:/usr/local/go/bin"
export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Add cargo to path
export PATH="$PATH:/root/.cargo/bin"

source $HOME/.local/share/aliases.sh
