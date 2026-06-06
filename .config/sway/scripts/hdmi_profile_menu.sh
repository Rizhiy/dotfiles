#!/bin/bash

set -euo pipefail

HDMI_OUTPUT="HDMI-A-1"
HDMI_SINK="alsa_output.pci-0000_09_00.1.hdmi-stereo"
HEADPHONES_SINK="alsa_output.usb-SteelSeries_Arctis_Nova_Pro_Wireless-00.analog-stereo"
SETUP_DISPLAYS="$HOME/.config/sway/scripts/setup_displays.sh"

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "HDMI profile" "$1"
    fi
}

choose_action() {
    printf '%s\n' \
        'Enable HDMI' \
        'Disable HDMI' \
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

enable_hdmi() {
    swaymsg output "$HDMI_OUTPUT" enable mode 3840x2160@60Hz scale 2
    "$SETUP_DISPLAYS"
    set_audio_sink "$HDMI_SINK"
    notify "Enabled $HDMI_OUTPUT and selected HDMI audio"
}

disable_hdmi() {
    swaymsg output "$HDMI_OUTPUT" disable
    "$SETUP_DISPLAYS"
    set_audio_sink "$HEADPHONES_SINK"
    notify "Disabled $HDMI_OUTPUT and selected headphones"
}

choice="${1:-}"
if [ -z "$choice" ]; then
    choice=$(choose_action)
fi

case "$choice" in
    "Enable HDMI"|enable)
        enable_hdmi
        ;;
    "Disable HDMI"|disable)
        disable_hdmi
        ;;
esac
