#!/bin/bash

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# added by Anaconda3 installer
export PATH="/home/rizhiy/anaconda3/bin:$PATH"
export PATH="/home/rizhiy/miniconda3/bin:$PATH"

# Install Vim plugins
vim +PluginInstall +qall &>/dev/null & disown;
# Compile YCM
python ~/.vim/bundle/youcompleteme/install.py --clangd-completer &>/dev/null & disown;

# Check gitconfig
grep_end="\[include\]\n\tpath = .gitconfig-general\n"
insert_end="[include]\n\tpath = .gitconfig-general\n"
if [[ -z "$( grep -Pzo "$grep_end" "$HOME"/.gitconfig | tr '\0' '\n' )" ]]; then
    echo "$insert_end" >> "$HOME"/.gitconfig
fi

cd "$HOME/.local/share/awesome-terminal-fonts"
./install.sh
cd -
sed 's/<family>PragmataPro<\/family>/<family>FontAwesome<\/family>/g' ~/.config/fontconfig/conf.d/10-symbols.conf &>/dev/null

# Install fzf
cd "$HOME/.local/share/fzf"
./install &>/dev/null & disown;
cd -

