#!/bin/bash

# Get all connected outputs with their info
outputs_json=$(swaymsg -t get_outputs -r)

# Config file for display order
display_order_file="$HOME/.config/sway/display_order"
# Config file for display transforms (rotations)
display_transforms_file="$HOME/.config/sway/display_transforms"

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

# Apply transforms to all displays if configured
if [ -f "$display_transforms_file" ]; then
    echo "Applying display transforms from $display_transforms_file"
    for display in "${output_array[@]}"; do
        transform=$(grep "^$display " "$display_transforms_file" | cut -d' ' -f2)
        if [ -n "$transform" ]; then
            echo "Applying transform $transform to $display"
            swaymsg output "$display" transform "$transform"
        fi
    done
fi

# Get the first output (primary/built-in display)
primary="${output_array[0]}"

echo "Primary display: $primary"

# If we have multiple displays, configure them
if [ ${#output_array[@]} -ge 2 ]; then
    # Get the primary display native width
    primary_native_width=$(echo "$outputs_json" | jq -r ".[] | select(.name == \"$primary\") | .current_mode.width")
    echo "Primary display native width: $primary_native_width"
    
    # Position primary at origin
    swaymsg output "$primary" pos 0 0
    
    # Track cumulative width for positioning
    cumulative_width=$(echo "$outputs_json" | jq -r ".[] | select(.name == \"$primary\") | .rect.width")
    
    # Process all non-primary displays
    for i in "${!output_array[@]}"; do
        if [ $i -eq 0 ]; then
            continue  # Skip primary
        fi
        
        display="${output_array[$i]}"
        echo "Configuring display: $display"
        
        # Get the native width of this display
        display_native_width=$(echo "$outputs_json" | jq -r ".[] | select(.name == \"$display\") | .current_mode.width")
        echo "Display $display native width: $display_native_width"
        
        # Calculate scale to match primary
        # Scale = display_native_width / primary_native_width
        scale=$(awk "BEGIN {printf \"%.2f\", $display_native_width / $primary_native_width}")
        echo "Display $display scale: $scale"
        
        # Set scale for this display
        swaymsg output "$display" scale "$scale"
        
        # Position this display to the right of previous displays
        swaymsg output "$display" pos "$cumulative_width" 0
        
        # Update cumulative width for next display
        display_width=$(echo "$outputs_json" | jq -r ".[] | select(.name == \"$display\") | .rect.width")
        cumulative_width=$((cumulative_width + display_width))
    done
    
    # Get secondary display (first non-primary) for workspace assignment
    secondary="${output_array[1]}"
    
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
