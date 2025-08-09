# Install pacman packages
cat $HOME/.local/share/pacman_install.txt | xargs sudo pacman --noconfirm -S
