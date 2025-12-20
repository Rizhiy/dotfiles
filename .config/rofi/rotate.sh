#!/usr/bin/env bash

# Get the focused output
output=$(swaymsg -t get_outputs | jq -r ".[] | select(.focused) | .name")
current=$(swaymsg -t get_outputs | jq -r ".[] | select(.name==\"$output\") | .transform")

echo "Current display: $output"
echo "Current rotation: $current"

# Rotation options
options="normal\n90\n180\n270"

# Show menu and get selection
selected=$(echo -e "$options" | wofi --dmenu --prompt "Rotate $output to:" --lines 4)

# Apply the selected rotation
if [ -n "$selected" ]; then
    swaymsg output "$output" transform "$selected"
    echo "Rotated $output to $selected"
fi
