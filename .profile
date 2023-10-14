#!/bin/bash

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
	PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/.bin" ] ; then
	PATH="$HOME/.bin:$PATH"
fi

# added by Anaconda3 installer
export PATH="/home/rizhiy/anaconda3/bin:$PATH"
export PATH="/home/rizhiy/miniconda3/bin:$PATH"

# Check gitconfig
config_path=".config/git/config"
grep_end="\[include\]\n\tpath = $config_path\n"
insert_end="[include]\n\tpath = $config_path\n"
if [[ -z "$( grep -Pzo "$grep_end" "$HOME"/.gitconfig | tr '\0' '\n' )" ]]; then
	printf "$insert_end" >> "$HOME"/.gitconfig
fi

# Set network interface names
export WIRELESS_NETWORK_INTERFACE=`ip a | grep wlp | awk '{print $2}' | head -n1 | sed 's/.$//'`
export WIRED_NETWORK_INTERFACE=`ip a | grep enp | awk '{print $2}' | head -n1 | sed 's/.$//'`

# Add flatpak dirs
XDG_DATA_DIRS="/var/lib/flatpak/exports/share:/home/rizhiy/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"
