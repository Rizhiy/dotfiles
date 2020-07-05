#!/bin/bash

sudo add-apt-repository ppa:mmstick76/alacritty -n -y
sudo add-apt-repository ppa:regolith-linux/release -n -y
sudo add-apt-repository ppa:lazygit-team/release -n -y
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
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
nvim +CocInstall +qall

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

# Install nerdfont
font_dir="$HOME/.local/share/fonts/NerdFonts"
mkdir -p "$font_dir"
cd "$font_dir"
font_links=(
	"https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf"
	"https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Bold/complete/Sauce%20Code%20Pro%20Bold%20Nerd%20Font%20Complete.ttf"
	"https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Italic/complete/Sauce%20Code%20Pro%20Italic%20Nerd%20Font%20Complete.ttf"
	"https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Bold-Italic/complete/Sauce%20Code%20Pro%20Bold%20Italic%20Nerd%20Font%20Complete.ttf"
)
for link in ${font_links[@]}; do
	wget -c "$link"
done
fc-cache -fv
cd ~

# Ytop
tmp_path="/tmp/ytop.tar.gz"
wget https://github.com/cjbassi/ytop/releases/download/0.6.2/ytop-0.6.2-x86_64-unknown-linux-gnu.tar.gz -O "$tmp_path"
tar xzf -C "$HOME/.bin" "$tmp_path"
rm -fr "$tmp_path"
