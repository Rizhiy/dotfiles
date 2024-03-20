# Increase history size
export HISTSIZE=10000

# set python debugger
export PYTHONBREAKPOINT=pudb.set_trace

# Set editor
export EDITOR=nvim

source $HOME/.local/share/aliases.sh

# Setup conda
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

if [ -z $CONDA_PREFIX ]; then
	conda activate
fi

if [ -z $PATHSSET ]; then
	# Add cuda to path
	export PATH="/usr/local/cuda/bin:/usr/local/cuda/NsightCompute-2019.1:$PATH"

	# Add user bin to PATH
	export PATH="$HOME/.bin:$PATH"

	# Add .local/bin to PATH
	export PATH="$HOME/.local/bin:$PATH"

	# Add Go to path
	export PATH="/usr/local/go/bin:$PATH"
	export GOPATH=$HOME/.go
	export PATH="$GOPATH/bin:$PATH"
	if [ ! -z $GOROOT ]; then
		export PATH="$GOROOT/bin:$PATH"
	fi

	# Add cargo to path
	export PATH="/root/.cargo/bin:$PATH"
	export PATH="$HOME/.cargo/bin:$PATH"

	# Variable to track if this was executed, keep at the bottom
	export PATHSSET=true
fi
