#!/usr/bin/env bash

# Config file for display transforms (rotations)
display_transforms_file="$HOME/.config/sway/display_transforms"

# Get the focused output
output=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
current=$(swaymsg -t get_outputs | jq -r ".[] | select(.name==\"$output\") | .transform")

echo "Current display: $output"
echo "Current rotation: $current"

# Show menu and get selection
selected=$(printf '󰑤  normal\n󰑦  90\n󰑥  180\n󰑧  270\n' \
    | wofi \
        --dmenu \
        --prompt "Rotate $output to:" \
        --lines 4 \
        --width 50% \
        --height 50% \
        --style "$HOME/.config/sway/wofi-keybindings.css" \
        --gtk-dark-theme \
        --insensitive)
selected=${selected#*  }

# Apply the selected rotation
if [ -n "$selected" ]; then
    swaymsg output "$output" transform "$selected"
    echo "Rotated $output to $selected"

    # Save the rotation to config file
    touch "$display_transforms_file"

    # Remove old entry for this output and add new one
    awk -v output="$output" '$1 != output' "$display_transforms_file" > "$display_transforms_file.tmp" 2>/dev/null || true
    echo "$output $selected" >> "$display_transforms_file.tmp"
    mv "$display_transforms_file.tmp" "$display_transforms_file"

    echo "Saved rotation to $display_transforms_file"
fi
