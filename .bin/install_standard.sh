#!/bin/bash

sudo add-apt-repository ppa:mmstick76/alacritty -n -y
sudo add-apt-repository ppa:regolith-linux/release -n -y
sudo add-apt-repository ppa:lazygit-team/release -n -y
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
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

# Install neovim
if [ ! -f "$HOME/.bin/nvim.appimage" ]; then
	wget "https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage" -O "$HOME/.bin/nvim.appimage" && chmod u+x "$HOME/.bin/nvim.appimage"
fi
sudo npm install -g neovim

# Install Vim plugins
nvim +PlugInstall +qall
nvim +CocInstall coc-python +qall
nvim +CocInstall coc-json +qall

cd "$HOME/.local/share/awesome-terminal-fonts"
./install.sh
cd -
sed 's/<family>PragmataPro<\/family>/<family>FontAwesome<\/family>/g' ~/.config/fontconfig/conf.d/10-symbols.conf

# Install fzf
cd "$HOME/.local/share/fzf"
yes | ./install
cd -

# Install git lfs
if ! git lfs &>/dev/null; then
	cd /tmp
	wget "https://github.com/git-lfs/git-lfs/releases/download/v2.10.0/git-lfs-linux-amd64-v2.10.0.tar.gz" -O "git-lfs.tar.gz" &&
		tar -xzf git-lfs.tar.gz &&
		sudo ./install.sh &&
		git lfs install
	cd -
fi

# Update config
config pull
