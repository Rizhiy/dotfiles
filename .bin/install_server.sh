#!/bin/bash
set -e
# Download all submodules
/usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" submodule update --init --recursive

# Always have latest git version
sudo add-apt-repository ppa:git-core/ppa -n -y
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get update

if [ ! -d "$HOME/miniconda3" ]; then
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O "$HOME/miniconda3.sh"
	bash "$HOME/miniconda3.sh" -b -p "$HOME/miniconda3"
	rm "$HOME/miniconda3.sh"
else
	echo "Miniconda installation found"
fi

if command -v pip > /dev/null; then
	pip install -r $HOME/.local/share/pip_install_server.txt
fi

xargs sudo apt-get install --no-install-recommends -y < $HOME/.local/share/apt_install_server.txt
sudo apt-get upgrade

# Install neovim
if [ ! -f "$HOME/.bin/nvim.appimage" ]; then
	wget "https://github.com/neovim/neovim/releases/download/v0.7.0/nvim.appimage" -O "$HOME/.bin/nvim.appimage" && chmod u+x "$HOME/.bin/nvim.appimage"
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

# Install fonts
# NerdFonts
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
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
fi
# Change default shell to zsh
chsh -s $(which zsh)

# Setup powerlevel9k
theme_path="$HOME/.oh-my-zsh/custom/themes/powerlevel9k"
if [[ ! -d "$theme_path" ]]; then
	git clone https://github.com/bhilburn/powerlevel9k.git "$theme_path"
fi

if ! command -b "bat" > /dev/null; then
	bat_path="/tmp/bat.deb"
	wget https://github.com/sharkdp/bat/releases/download/v0.17.1/bat_0.17.1_amd64.deb -O "$bat_path" &&
	sudo dpkg -i "$bat_path"
	rm -fr "$bat_path"
fi

# Lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v*([^"]+)".*/\1/')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit
rm lazygit.tar.gz
