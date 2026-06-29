#!/bin/bash

set -euo pipefail

HDMI_OUTPUT="HDMI-A-1"
MAIN_OUTPUTS=("DP-1" "DP-2")
HDMI_SINK="alsa_output.pci-0000_09_00.1.hdmi-stereo"
HEADPHONES_SINK="alsa_output.usb-SteelSeries_Arctis_Nova_Pro_Wireless-00.analog-stereo"
SETUP_DISPLAYS="$HOME/.config/sway/scripts/setup_displays.sh"
DISPLAY_STATES_FILE="$HOME/.config/sway/display_states"

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send --expire-time=3000 "HDMI profile" "$1"
    fi
}

choose_action() {
    printf '%s\n' \
        'Main' \
        'HDMI only' \
        'All' \
        | wofi \
            --dmenu \
            --prompt 'HDMI profile' \
            --width 50% \
            --height 50% \
            --style "$HOME/.config/sway/wofi-keybindings.css" \
            --gtk-dark-theme \
            --insensitive
}

sink_id() {
    pw-dump | jq -r --arg name "$1" '
        .[]
        | select(.type == "PipeWire:Interface:Node")
        | select(.info.props["media.class"] == "Audio/Sink")
        | select(.info.props["node.name"] == $name)
        | .id
    ' | head -n 1
}

set_audio_sink() {
    local sink_name="$1"
    local id

    id=$(sink_id "$sink_name")
    if [ -z "$id" ]; then
        notify "Audio sink not found: $sink_name"
        exit 1
    fi

    wpctl set-default "$id"
    pactl set-default-sink "$sink_name"

    pactl list short sink-inputs | while read -r input _; do
        pactl move-sink-input "$input" "$sink_name" || true
    done
}

save_display_state() {
    local output="$1"
    local state="$2"

    touch "$DISPLAY_STATES_FILE"
    awk -v output="$output" '$1 != output' "$DISPLAY_STATES_FILE" > "$DISPLAY_STATES_FILE.tmp" 2>/dev/null || true
    echo "$output $state" >> "$DISPLAY_STATES_FILE.tmp"
    mv "$DISPLAY_STATES_FILE.tmp" "$DISPLAY_STATES_FILE"
}

ensure_display_enabled() {
    local first_output

    if awk '$1 !~ /^#/ && ($2 == "enabled" || $2 == "enable") { found = 1 } END { exit !found }' "$DISPLAY_STATES_FILE"; then
        return
    fi

    first_output=$(awk '$1 !~ /^#/ { print $1; exit }' "$DISPLAY_STATES_FILE")
    if [ -n "$first_output" ]; then
        save_display_state "$first_output" enabled
        swaymsg output "$first_output" enable
    fi
}

apply_display_setup() {
    ensure_display_enabled
    "$SETUP_DISPLAYS"
}

enable_main_outputs() {
    for output in "${MAIN_OUTPUTS[@]}"; do
        save_display_state "$output" enabled
        swaymsg output "$output" enable
    done
}

disable_main_outputs() {
    for output in "${MAIN_OUTPUTS[@]}"; do
        save_display_state "$output" disabled
        swaymsg output "$output" disable
    done
}

enable_hdmi_output() {
    save_display_state "$HDMI_OUTPUT" enabled
    swaymsg output "$HDMI_OUTPUT" enable mode 3840x2160@60Hz scale 2
}

disable_hdmi_output() {
    save_display_state "$HDMI_OUTPUT" disabled
    swaymsg output "$HDMI_OUTPUT" disable
}

main_profile() {
    enable_main_outputs
    disable_hdmi_output
    apply_display_setup
    set_audio_sink "$HEADPHONES_SINK"
    notify "Main: DP-1 and DP-2 enabled, HDMI disabled, headphones selected"
}

hdmi_only_profile() {
    disable_main_outputs
    enable_hdmi_output
    apply_display_setup
    set_audio_sink "$HDMI_SINK"
    notify "HDMI only: DP-1 and DP-2 disabled, HDMI audio selected"
}

all_profile() {
    enable_main_outputs
    enable_hdmi_output
    apply_display_setup
    set_audio_sink "$HDMI_SINK"
    notify "All: all displays enabled, HDMI audio selected"
}

choice="${1:-}"
if [ -z "$choice" ]; then
    choice=$(choose_action)
fi

case "$choice" in
    "Main"|main)
        main_profile
        ;;
    "HDMI only"|hdmi-only)
        hdmi_only_profile
        ;;
    "All"|all)
        all_profile
        ;;
esac
