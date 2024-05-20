#!/bin/bash

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
