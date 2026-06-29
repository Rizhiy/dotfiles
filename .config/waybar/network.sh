#!/usr/bin/env bash

set -euo pipefail

state_dir="${XDG_RUNTIME_DIR:-/tmp}/waybar-network-speed"
state_file="$state_dir/state"

mkdir -p "$state_dir"

iface=""
if command -v ip >/dev/null 2>&1; then
  iface=$(ip route get 1.1.1.1 2>/dev/null | awk '{for (i = 1; i <= NF; i++) if ($i == "dev") {print $(i + 1); exit}}')
fi

if [[ -z "$iface" || ! -r "/sys/class/net/$iface/statistics/rx_bytes" ]]; then
  printf '{"text":"󰖪 Disconnected","class":"disconnected"}\n'
  exit 0
fi

rx=$(<"/sys/class/net/$iface/statistics/rx_bytes")
tx=$(<"/sys/class/net/$iface/statistics/tx_bytes")
now=$(date +%s)

prev_iface=""
prev_rx="$rx"
prev_tx="$tx"
prev_now="$now"

if [[ -r "$state_file" ]]; then
  read -r prev_iface prev_rx prev_tx prev_now < "$state_file" || true
fi

printf '%s %s %s %s\n' "$iface" "$rx" "$tx" "$now" > "$state_file"

elapsed=$((now - prev_now))
if [[ "$prev_iface" != "$iface" || $elapsed -le 0 ]]; then
  up="0.00"
  down="0.00"
else
  up=$(awk -v bytes=$((tx - prev_tx)) -v seconds="$elapsed" 'BEGIN { printf "%.2f", bytes / seconds / 1000000 }')
  down=$(awk -v bytes=$((rx - prev_rx)) -v seconds="$elapsed" 'BEGIN { printf "%.2f", bytes / seconds / 1000000 }')
fi

icon="󰈀"
label="$iface"
if [[ -d "/sys/class/net/$iface/wireless" ]]; then
  icon="󰖩"
  if command -v iwgetid >/dev/null 2>&1; then
    ssid=$(iwgetid -r "$iface" 2>/dev/null || true)
    [[ -n "$ssid" ]] && label="$ssid"
  fi
fi

printf '{"text":"%s %s ↑%s MB/s ↓%s MB/s","tooltip":"%s: U %s MB/s D %s MB/s"}\n' "$icon" "$label" "$up" "$down" "$iface" "$up" "$down"
