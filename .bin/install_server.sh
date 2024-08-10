#!/bin/bash
set -e
# Download all submodules
/usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" submodule update --init --recursive

# Install basic stuff first
xargs sudo apt-get install --no-install-recommends -y < $HOME/.local/share/apt_install_first.txt

# Always have latest git version
sudo add-apt-repository ppa:git-core/ppa -n -y
# Add onefetch
sudo add-apt-repository ppa:o2sh/onefetch -n -y
# Add node ppa
mkdir -p /etc/apt/keyrings
if ! command -v node > /dev/null; then
	curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor | sudo tee /etc/apt/keyrings/nodesource.gpg > /dev/null \
	&& NODE_MAJOR=20 \
	&& echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list > /dev/null
fi
# Install rust
if ! command -v rustup > /dev/null; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
# Add GitHub CLI ppa
if ! command -v gh > /dev/null; then
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
	&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
fi

architecture="$(dpkg --print-architecture)"
if [ ! -d "$HOME/miniconda3" ]; then
	if [ "$architecture" = "amd64" ]; then
		download_link="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
	elif [ "$architecture" = "arm64" ]; then
		download_link="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
	else
		echo "Unknown architecture! ${architecture}"
		exit 1
	fi
	wget "$download_link" -O "$HOME/miniconda3.sh"
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

os="$(lsb_release -i)"
if ! command -v npm > /dev/null; then
	# Debian doesn't install npm with node, so need custom logic here
	case "$os" in
		*Ubuntu*)
			node_package="nodejs"
			;;
		*Debian*)
			node_package="npm"
			;;
		*)
			echo "Unknown os: ${os}"
			exit 1
			;;
	esac
	sudo apt install "$node_package"
fi

# Link fd
if ! command -v fd > /dev/null; then
	ln -s $(which fdfind) ~/.bin/fd
fi

if ! command -v nvim > /dev/null; then
	# AppImage doesn't work on raspberry pi, so build from source
	if [ "$architecture" = "amd64" ]; then
		nvim_path="/opt/neovim/nvim.appimage"
		sudo mkdir -p $(dirname $nvim_path)
		sudo wget "https://github.com/neovim/neovim/releases/download/stable/nvim.appimage" -O "$nvim_path" && sudo chmod +x "$nvim_path"
		sudo ln -s /opt/neovim/nvim.appimage /usr/local/bin/nvim
	elif [ "$architecture" = "arm64" ]; then
		# Ensure prerequisites are installed
		sudo apt-get install ninja-build gettext cmake unzip curl build-essential
		# Based on https://forums.raspberrypi.com/viewtopic.php?t=367119#p2203414
		current_dir="$(pwd)"
		clone_dir="/tmp/neovim-clone"
		mkdir "$clone_dir"
		git clone https://github.com/neovim/neovim.git "$clone_dir"

		cd "$clone_dir"
		git checkout stable
		make CMAKE_BUILD_TYPE=Release
		cd build && sudo cpack -G DEB && sudo dpkg -i nvim-linux64.deb

		cd "$current_dir"
		rm -fr "$clone-dir"
	else
		echo "Unknown architecture! ${architecture}"
		exit 1
	fi
fi
sudo npm install -g neovim

# Install insect (terminal calculator)
if ! command -v insect > /dev/null; then
	sudo npm install -g insect
fi

# Install deno - JS runtime
if ! command -v deno > /dev/null; then
	curl -fsSL deno.land/x/install/install.sh | sudo DENO_INSTALL=/usr/local sh
fi

# Install Vim plugins
nvim --headless "+Lazy! sync" +qa

# Install fzf
cd "$HOME/.local/share/fzf"
	yes | ./install
cd -

if ! git lfs &>/dev/null; then
	cd /tmp
	wget "https://github.com/git-lfs/git-lfs/releases/download/v2.10.0/git-lfs-linux-amd64-v2.10.0.tar.gz" -O "git-lfs.tar.gz" &&
		tar -xzf git-lfs.tar.gz &&
		sudo ./install.sh &&
		git lfs install
	cd -
fi

# NerdFonts
font_dir="$HOME/.local/share/fonts/NerdFonts"
mkdir -p "$font_dir"
cd "$font_dir"
if [ ! -f "SauceCodeProNerdFont-Regular.ttf" ]; then
	wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/SourceCodePro.zip"
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

if ! command -v lsd > /dev/null; then
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

if ! command -v tmux > /dev/null; then
	wget https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz -O /tmp/tmux.tar.gz
	current_dir=$(pwd)
	cd /tmp
		tar -xzf tmux.tar.gz
		cd tmux-3.3a
			./configure && make
			make && sudo make install
	cd "$current_dir"
fi

if ! command -v htop > /dev/null; then
	wget https://github.com/htop-dev/htop/releases/download/3.2.2/htop-3.2.2.tar.xz -O /tmp/htop.tar.xz
	current_dir=$(pwd)
	cd /tmp
		tar -xf htop.tar.xz
		cd htop-3.2.2
			./autogen.sh && ./configure && make
			sudo make install
	cd "$current_dir"
fi

if ! command -v lazygit > /dev/null; then
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

if ! command -v zoxide > /dev/null; then
	curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

if ! command -v selene > /dev/null; then
	cargo install selene
fi
