#!/usr/bin/env bash

# Config file for display transforms (rotations)
display_transforms_file="$HOME/.config/sway/display_transforms"

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
    
    # Save the rotation to config file
    # Create file if it doesn't exist
    touch "$display_transforms_file"
    
    # Remove old entry for this output and add new one
    grep -v "^$output " "$display_transforms_file" > "$display_transforms_file.tmp" 2>/dev/null || true
    echo "$output $selected" >> "$display_transforms_file.tmp"
    mv "$display_transforms_file.tmp" "$display_transforms_file"
    
    echo "Saved rotation to $display_transforms_file"
fi
