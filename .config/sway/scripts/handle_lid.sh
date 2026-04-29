#!/usr/bin/env bash

set -euo pipefail

action=${1:-}
outputs_json=$(swaymsg -t get_outputs -r)

internal_output=$(jq -r '.[] | select(.name | test("^eDP")) | .name' <<< "$outputs_json" | head -n 1)
external_count=$(jq '[.[] | select(.active == true and (.name | test("^eDP") | not))] | length' <<< "$outputs_json")

if [[ -z "$internal_output" ]]; then
  exit 0
fi

case "$action" in
  close)
    if (( external_count > 0 )); then
      swaymsg output "$internal_output" disable >/dev/null
      "$HOME/.config/sway/scripts/setup_displays.sh" >/dev/null 2>&1 || true
    fi
    ;;
  open)
    swaymsg output "$internal_output" enable >/dev/null
    "$HOME/.config/sway/scripts/setup_displays.sh" >/dev/null 2>&1 || true
    ;;
  *)
    exit 1
    ;;
esac
