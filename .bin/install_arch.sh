#!/usr/bin/env bash
set -e

share_dir=$HOME/.local/share/

function echo_stage {
    echo "===== $1 ====="
}

function read_without_comments {
    while read -r line
    do
        [[ $line = \#* ]] && continue
        echo $line
    done < "$1"
}

echo_stage "Checking out config files"
# Make sure we are on the correct branch
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout master

echo_stage "Enabling multilib"
sudo sed -i -e '/#\[multilib\]/,+1s/^#//' /etc/pacman.conf
sudo pacman -Sy

echo_stage "Installing with pacman"
read_without_comments $share_dir/pacman_install.txt | xargs sudo pacman --needed --noconfirm -S
# Install yay for AUR
if ! command -v yay > /dev/null; then
    git clone https://aur.archlinux.org/yay.git \
        && cd yay \
        && makepkg -si \
        && cd .. \
        && rm -rf yay
fi

echo_stage "Updating firmware"
fwupdmgr refresh --force
fwupdmgr update -y --no-reboot-check

echo_stage "Installing with yay"
read_without_comments $share_dir/yay_install.txt | xargs yay --needed --noconfirm -S

echo_stage "Refresh fonts"
fc-cache -fv

# Make sure that correct services are enabled
echo_stage "Enabling and starting services"
read_without_comments $share_dir/systemctl_enable_root.txt | xargs sudo systemctl enable --now
read_without_comments $share_dir/systemctl_enable_user.txt | xargs systemctl --user enable --now

echo_stage "Setup NordVPN"
sudo groupadd -f nordvpn
sudo usermod -aG nordvpn $USER
