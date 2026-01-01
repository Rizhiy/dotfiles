#!/bin/sh
swayidle \
    timeout 5 'swaymsg "output * power off"' \
    resume 'swaymsg "output * power on"' &
swaylock -li $HOME/.local/share/lock_screen.jpg --font "SauceCodePro Nerd Font"
kill %%
