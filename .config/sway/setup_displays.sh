#!/bin/bash

# Get all connected outputs with their info
outputs_json=$(swaymsg -t get_outputs -r)

# Config file for display order
display_order_file="$HOME/.config/sway/display_order"

# Get output names
if [ -f "$display_order_file" ]; then
    echo "Using display order from $display_order_file"
    # Read display order from file, filter only active displays
    output_array=()
    while IFS= read -r display_name; do
        # Skip empty lines and comments
        [[ -z "$display_name" || "$display_name" =~ ^[[:space:]]*# ]] && continue
        # Check if display is active
        if echo "$outputs_json" | jq -e ".[] | select(.name == \"$display_name\" and .active == true)" > /dev/null; then
            output_array+=("$display_name")
        fi
    done < "$display_order_file"
else
    echo "No display order file found, using sorted order"
    # Get output names sorted
    outputs=$(echo "$outputs_json" | jq -r '.[] | select(.active == true) | .name' | sort)
    # Convert to array
    readarray -t output_array <<< "$outputs"
fi

# Check if we have at least one output
if [ ${#output_array[@]} -eq 0 ]; then
    echo "No active outputs found"
    exit 1
fi

# Get the first output (primary/built-in display)
primary="${output_array[0]}"

echo "Primary display: $primary"

# If we have a second display, position it to the right of the first
if [ ${#output_array[@]} -ge 2 ]; then
    secondary="${output_array[1]}"
    echo "Secondary display: $secondary"
    
    # Get the native width of both displays
    primary_native_width=$(echo "$outputs_json" | jq -r ".[] | select(.name == \"$primary\") | .current_mode.width")
    secondary_native_width=$(echo "$outputs_json" | jq -r ".[] | select(.name == \"$secondary\") | .current_mode.width")
    
    # Get current width for positioning
    primary_width=$(echo "$outputs_json" | jq -r ".[] | select(.name == \"$primary\") | .rect.width")
    
    echo "Primary display native width: $primary_native_width"
    echo "Secondary display native width: $secondary_native_width"
    
    # Calculate scale for secondary display to match primary
    # Scale = secondary_native_width / primary_native_width
    scale=$(awk "BEGIN {printf \"%.2f\", $secondary_native_width / $primary_native_width}")
    echo "Secondary display scale: $scale"
    
    # Set scale for secondary display
    swaymsg output "$secondary" scale "$scale"
    
    # Position primary at origin and secondary to the right of primary
    swaymsg output "$primary" pos 0 0
    swaymsg output "$secondary" pos "$primary_width" 0
    
    # Assign odd workspaces to primary, even to secondary
    for i in 1 3 5 7 9; do
        swaymsg workspace "$i" output "$primary"
    done
    
    for i in 2 4 6 8 10; do
        swaymsg workspace "$i" output "$secondary"
    done
    
    echo "Workspaces assigned: odd to $primary, even to $secondary"
else
    echo "Single display setup"
    # All workspaces on the single display
    for i in 1 2 3 4 5 6 7 8 9 10; do
        swaymsg workspace "$i" output "$primary"
    done
fi
