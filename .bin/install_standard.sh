#!/bin/bash
set -e

bash $HOME/.bin/install_server.sh

echo "Adding ppas"
# Nice terminal
sudo add-apt-repository ppa:aslatter/ppa -n -y
# Proper i3
/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2024.03.04_all.deb keyring.deb SHA256:f9bb4340b5ce0ded29b7e014ee9ce788006e9bbfe31e96c09b2118ab91fca734
sudo apt install ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
# Ueberzugpp - image viewer
echo 'deb http://download.opensuse.org/repositories/home:/justkidding/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/home:justkidding.list
curl -fsSL https://download.opensuse.org/repositories/home:justkidding/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_justkidding.gpg > /dev/null

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

xargs sudo apt-get install --no-install-recommends -y < $HOME/.local/share/apt_install_gui.txt
sudo apt-get upgrade -y

if command -v "pip"; then
	pip install -r $HOME/.local/share/pip_install_gui.txt
fi

#WeatherIcons
font_dir="$HOME/.local/share/fonts/WeatherIcons"
mkdir -p "$font_dir"
cd "$font_dir"
ln -s -f ../../weather-icons/font/weathericons-regular-webfont.ttf .
fc-cache -fv
cd ~

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
if ! command -v "betterlockscreen" > /dev/null; then
	wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system
	betterlockscreen -u "$HOME/.local/share/lock_screen.jpg"
fi

# Add user to video group for brightness
sudo usermod -a -G video "$(whoami)"

# Weather for polybar
forecast_path="$HOME/.bin/polybar-forecast"
wget https://github.com/kamek-pf/polybar-forecast/releases/download/v1.1.0/polybar-forecast-linux-x86_64 -O "$forecast_path"
chmod +x "$forecast_path"

# Install git-delta
if ! command -v "delta" > /dev/null; then
	wget https://github.com/dandavison/delta/releases/download/0.15.1/delta-0.15.1-x86_64-unknown-linux-musl.tar.gz -O /tmp/delta.tar.gz
	tar -xvf /tmp/delta.tar.gz -C /tmp
	mv /tmp/delta-0.15.1-x86_64-unknown-linux-musl/delta ~/.bin
fi

# Install anki
if ! command -v "anki" > /dev/null; then
    wget https://github.com/ankitects/anki/releases/download/23.10.1/anki-23.10.1-linux-qt6.tar.zst -O /tmp/anki.tar.zst
    tar --use-compress-program=unzstd -xvf /opt/anki.tar.zst -C /tmp/anki
    cd /tmp/anki
    sudo ./install.sh
    cd -
fi
