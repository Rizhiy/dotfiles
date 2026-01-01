#!/bin/bash
# Script to show all Sway keybindings in a searchable popup

CONFIG_DIR="$HOME/.config/sway"
TEMP_FILE=$(mktemp)
JSON_FILE="$CONFIG_DIR/keybindings.json"

# Load descriptions from JSON file once
declare -A descriptions
if [[ -f "$JSON_FILE" ]]; then
    while IFS= read -r line; do
        if [[ $line =~ \"([^\"]+)\":[[:space:]]*\"([^\"]+)\" ]]; then
            descriptions["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}"
        fi
    done < "$JSON_FILE"
fi

# Function to get description for a keybinding
get_description() {
    local key="$1"
    local mode="$2"
    
    # Check for mode-specific binding first
    if [[ -n $mode ]]; then
        local mode_key="[$mode] $key"
        if [[ -n "${descriptions[$mode_key]}" ]]; then
            echo "${descriptions[$mode_key]}"
            return
        fi
    fi
    
    # Check for regular binding
    if [[ -n "${descriptions[$key]}" ]]; then
        echo "${descriptions[$key]}"
        return
    fi
    
    # No description found
    echo ""
}

# Function to process keybindings from a config file
process_config() {
    local file="$1"
    local in_mode=""
    
    while IFS= read -r line; do
        # Check if entering a mode
        if [[ $line =~ ^mode[[:space:]]+\"([^\"]+)\" ]]; then
            in_mode="${BASH_REMATCH[1]}"
            continue
        fi
        
        # Check if exiting a mode
        if [[ $line =~ ^\} ]] && [[ -n $in_mode ]]; then
            in_mode=""
            continue
        fi
        
        # Process bindsym lines
        if [[ $line =~ ^[[:space:]]*bindsym[[:space:]]+(.+) ]]; then
            local binding="${BASH_REMATCH[1]}"
            
            # Split on exec or other commands
            if [[ $binding =~ ^([^[:space:]]+)[[:space:]]+(.+)$ ]]; then
                local key="${BASH_REMATCH[1]}"
                local action="${BASH_REMATCH[2]}"
                
                # Save original key for JSON lookup
                local json_key="$key"
                
                # Replace variables for display
                key="${key//\$mod/Super}"
                key="${key//\$alt/Alt}"
                key="${key//\$left/h}"
                key="${key//\$right/l}"
                key="${key//\$up/k}"
                key="${key//\$down/j}"
                
                # Get description from JSON
                local description=$(get_description "$json_key" "$in_mode")
                
                # Add mode prefix if in a mode
                if [[ -n $in_mode ]]; then
                    key="[$in_mode] $key"
                fi
                
                # Use description if available, otherwise show action
                if [[ -n $description ]]; then
                    printf "%-35s  %s\n" "$key" "$description"
                else
                    # Clean up the action
                    action="${action#exec }"
                    action="${action#\"}"
                    action="${action%\"}"
                    printf "%-35s  %s\n" "$key" "$action"
                fi
            fi
        fi
    done < "$file"
}

# Extract keybindings from all config files
{
    # Process main config
    if [[ -f "$CONFIG_DIR/config" ]]; then
        process_config "$CONFIG_DIR/config"
    fi
    
    # Process keys.conf
    if [[ -f "$CONFIG_DIR/keys.conf" ]]; then
        process_config "$CONFIG_DIR/keys.conf"
    fi
    
    # Sort and remove duplicates
} | sort -u > "$TEMP_FILE"

# Show in wofi with custom styling
cat "$TEMP_FILE" | wofi \
    --show dmenu \
    --prompt "Keybindings" \
    --width 50% \
    --height 50% \
    --style "$HOME/.config/sway/wofi-keybindings.css" \
    --dmenu-print-line-num false \
    --gtk-dark-theme \
    --insensitive

# Cleanup
rm -f "$TEMP_FILE"
