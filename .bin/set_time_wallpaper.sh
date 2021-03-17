#!/bin/bash
# Set wallpaper based on time
set_time_wallpaper() {
	declare -a imgs
	for img in $HOME/.local/share/Lakeside_Louis_Coyle/*; do
		imgs=("${imgs[@]}" "$img")
	done
	imgs=($(printf "%s\n" ${imgs[@]} | sort -V))
	hour=$(date +'%H')
	idx=$(( "10#$hour" / 2 ))
	feh --bg-fill ${imgs[$idx]}
}
set_time_wallpaper
