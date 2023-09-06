#!/bin/bash
set -e
# Download all submodules
/usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" submodule update --init --recursive

# Always have latest git version
sudo add-apt-repository ppa:git-core/ppa -n -y
# Add node ppa
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor | sudo tee /etc/apt/keyrings/nodesource.gpg > /dev/null
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list > /dev/null

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
sudo apt-get upgrade -y

# Install neovim
if [ ! -f "$HOME/.bin/nvim.appimage" ]; then
	wget "https://github.com/neovim/neovim/releases/download/stable/nvim.appimage" -O "$HOME/.bin/nvim.appimage" && chmod u+x "$HOME/.bin/nvim.appimage"
fi
sudo npm install -g neovim

# Install insect (terminal calculator)
if ! command -v "insect" > /dev/null; then
	sudo npm install -g insect
fi

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
if [ ! -f "SauceCodeProNerdFont-Regular.ttf" ]; then
	wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/SourceCodePro.zip"
	unzip -n SourceCodePro.zip
	rm SourceCodePro.zip
fi
fc-cache -fv
cd -


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

# Change default shell to zsh
sudo usermod -s $(which zsh) $(whoami)

# Lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v*([^"]+)".*/\1/')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit
rm lazygit.tar.gz

# Install newer version of tmux
if ! command -v "tmux" > /dev/null; then
	wget https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz -O /tmp/tmux.tar.gz
	current_dir=$(pwd)
	cd /tmp
		tar -xzf tmux.tar.gz
		cd tmux-3.3a
			./configure && make
			make && sudo make install
	cd "$current_dir"
fi

# Install newer version of htop
if ! command -v "htop" > /dev/null; then
	wget https://github.com/htop-dev/htop/releases/download/3.2.2/htop-3.2.2.tar.xz -O /tmp/htop.tar.xz
	current_dir=$(pwd)
	cd /tmp
		tar -xf htop.tar.xz
		cd htop-3.2.2
			./autogen.sh && ./configure && make
			sudo make install
	cd "$current_dir"
fi

# Install lazygit
if ! command -v "lazygit" > /dev/null; then
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
	wget "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" -O /tmp/lazygit.tar.gz
	current_dir=$(pwd)
	cd /tmp
		tar -xf lazygit.tar.gz lazygit
		sudo install lazygit /usr/local/bin
	cd "$current_dir"
fi

# Symlink bat to batcat
if [ ! -f "/usr/local/bin/bat" ]; then
	sudo ln -s /usr/bin/batcat /usr/local/bin/bat
fi
