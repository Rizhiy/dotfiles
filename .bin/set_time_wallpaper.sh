#!/bin/bash
# Set wallpaper based on time
set_time_wallpaper() {
	imgs=($(ls -dv $HOME/.local/share/Lakeside_Louis_Coyle/*))
	hour=$(date +'%H')
	idx=$(( $hour / 2 ))
	feh --bg-fill ${imgs[$idx]}
}
set_time_wallpaper
