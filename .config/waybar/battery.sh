#!/usr/bin/env bash

set -euo pipefail

device="/org/freedesktop/UPower/devices/DisplayDevice"
percentage=""
state=""
time_remaining=""

while IFS= read -r line; do
  case "$line" in
    *"percentage:"*)
      percentage=${line#*:}
      percentage=${percentage//[[:space:]]/}
      ;;
    *"state:"*)
      state=${line#*:}
      state=${state#${state%%[![:space:]]*}}
      ;;
    *"time to empty:"*|*"time to full:"*)
      time_remaining=${line#*:}
      time_remaining=${time_remaining#${time_remaining%%[![:space:]]*}}
      ;;
  esac
done < <(upower -i "$device")

if [[ -z "$percentage" ]]; then
  printf '{"text":"","class":"missing"}\n'
  exit 0
fi

capacity=${percentage%%%}
icon="󰁹"

if [[ "$state" == "charging" ]]; then
  icon="󰂄"
elif [[ "$state" == "fully-charged" ]]; then
  icon="󰚥"
elif (( capacity <= 10 )); then
  icon="󰂎"
elif (( capacity <= 20 )); then
  icon="󰁺"
elif (( capacity <= 30 )); then
  icon="󰁻"
elif (( capacity <= 40 )); then
  icon="󰁼"
elif (( capacity <= 50 )); then
  icon="󰁽"
elif (( capacity <= 60 )); then
  icon="󰁾"
elif (( capacity <= 70 )); then
  icon="󰁿"
elif (( capacity <= 80 )); then
  icon="󰂀"
elif (( capacity <= 90 )); then
  icon="󰂁"
elif (( capacity < 100 )); then
  icon="󰂂"
fi

tooltip="$state"
if [[ -n "$time_remaining" ]]; then
  tooltip+=" ($time_remaining)"
fi

css_class="$state"
if [[ "$state" != "charging" && "$state" != "fully-charged" ]]; then
  if (( capacity <= 15 )); then
    css_class="critical"
  elif (( capacity <= 30 )); then
    css_class="warning"
  fi
fi

printf '{"text":"%s %s","tooltip":"%s","class":"%s"}\n' "$icon" "$percentage" "$tooltip" "$css_class"
