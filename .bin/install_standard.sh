#!/bin/bash
set -e
# Download all submodules
/usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" submodule update --init --recursive

echo "Adding ppas"
# Always have latest git version
sudo add-apt-repository ppa:git-core/ppa -n -y
# Nice terminal
sudo add-apt-repository ppa:mmstick76/alacritty -n -y
# i3-gaps & friends
sudo add-apt-repository ppa:kgilmer/speed-ricer -n -y
# Interactive git interface
sudo add-apt-repository ppa:lazygit-team/release -n -y
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
if ! command -v "google-chrome-stable"; then
	wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'
fi
if ! command -v "nordvpn" > /dev/null; then
	deb_path="/tmp/nordvpn.deb"
	wget "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb" -O "$deb_path" &&
	sudo dpkg -i "$deb_path"
	rm -fr "$deb_path"
fi
sudo apt-get update

xargs sudo apt-get install --no-install-recommends -y < $HOME/.local/share/apt_install.txt
sudo apt-get upgrade

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
"$HOME/.bin/nvim.appimage" +PlugInstall +qall
"$HOME/.bin/nvim.appimage" +CocInstall +qall

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

if ! command -v ytop > /dev/null; then
	ytop_path="/tmp/ytop.tar.gz"
	wget "https://github.com/cjbassi/ytop/releases/download/0.6.2/ytop-0.6.2-x86_64-unknown-linux-gnu.tar.gz" -O "$ytop_path" &&
	tar -xzf "$ytop_path" -C "$HOME/.bin"
	rm -fr "$ytop_path"
fi

if ! command -v "lsd" > /dev/null; then
	lsd_path="/tmp/lsd_18.deb"
	wget "https://github.com/Peltoche/lsd/releases/download/0.18.0/lsd_0.18.0_amd64.deb" -O "$lsd_path" &&
	sudo dpkg -i "$lsd_path"
	rm -fr "$lsd_path"
fi

# Install oh-my-zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Setup powerlevel9k
theme_path="$HOME/.oh-my-zsh/custom/themes/powerlevel9k"
if [[ ! -d "$theme_path" ]]; then
	git clone https://github.com/bhilburn/powerlevel9k.git "$theme_path"
fi

# Install unclutter
if ! command -v "unclutter" > /dev/null; then
	cd "$HOME/.local/share/unclutter-xfixes"
	make
	sudo make install
	cd -
fi

# Add i3 option
source_path="$HOME/.local/share/i3.desktop"
target_path="/usr/share/xsessions/i3.desktop"
if [[ ! -f "$target_path" ]]; then
	sudo cp "$source_path" "$target_path"
fi

# Build i3lock-color
if ! command -v "i3lock" > /dev/null; then
	old_dir="$(pwd)"
	cd $HOME/.local/share/i3lock-color
	chmod u+x build.sh
	./build.sh
	cd build
	sudo make install
	cd "$old_dir"
fi

# Update lockscreenwallpaper
"$HOME/.local/share/multilockscreen/multilockscreen" -u "$HOME/.local/share/lock_screen.jpg"

# Add user to video group for brightness
sudo usermod -a -G video "$(whoami)"

if ! command -b "bat" > /dev/null; then
	bat_path="/tmp/bat.deb"
	wget https://github.com/sharkdp/bat/releases/download/v0.17.1/bat_0.17.1_amd64.deb -O "$bat_path" &&
	sudo dpkg -i "$bat_path"
	rm -fr "$bat_path"
fi
