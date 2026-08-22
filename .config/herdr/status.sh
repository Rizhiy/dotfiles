#!/usr/bin/env bash

# Compact, dependency-light status line for Herdr's bottom tab bar.
set -u

runtime_dir=${XDG_RUNTIME_DIR:-/tmp}
state_file="$runtime_dir/herdr-status-$UID"
now=$(date +%s)

read -r _ cpu_user cpu_nice cpu_system cpu_idle cpu_iowait cpu_irq cpu_softirq cpu_steal _ < /proc/stat
cpu_total=$((cpu_user + cpu_nice + cpu_system + cpu_idle + cpu_iowait + cpu_irq + cpu_softirq + cpu_steal))
cpu_idle_total=$((cpu_idle + cpu_iowait))

interface=$(ip -o route show default 2>/dev/null | awk 'NR == 1 { print $5 }')
rx=0
tx=0
if [[ -n $interface && -r /sys/class/net/$interface/statistics/rx_bytes ]]; then
    rx=$(<"/sys/class/net/$interface/statistics/rx_bytes")
    tx=$(<"/sys/class/net/$interface/statistics/tx_bytes")
fi

previous_total=0
previous_idle=0
previous_rx=$rx
previous_tx=$tx
previous_time=$now
if [[ -r $state_file ]]; then
    read -r previous_total previous_idle previous_rx previous_tx previous_time < "$state_file" || true
fi
printf '%s %s %s %s %s\n' "$cpu_total" "$cpu_idle_total" "$rx" "$tx" "$now" > "$state_file"

cpu='--'
total_delta=$((cpu_total - previous_total))
idle_delta=$((cpu_idle_total - previous_idle))
if (( previous_total > 0 && total_delta > 0 )); then
    cpu=$((100 * (total_delta - idle_delta) / total_delta))
fi

elapsed=$((now - previous_time))
(( elapsed > 0 )) || elapsed=1
rx_rate=$(((rx - previous_rx) / elapsed))
tx_rate=$(((tx - previous_tx) / elapsed))
(( rx_rate >= 0 )) || rx_rate=0
(( tx_rate >= 0 )) || tx_rate=0

human_rate() {
    awk -v bytes="$1" 'BEGIN {
        if (bytes >= 1048576) printf "%.1fM", bytes / 1048576;
        else if (bytes >= 1024) printf "%.0fK", bytes / 1024;
        else printf "%dB", bytes;
    }'
}

mem_total=$(awk '/^MemTotal:/ { print $2 }' /proc/meminfo)
mem_available=$(awk '/^MemAvailable:/ { print $2 }' /proc/meminfo)
mem=$((100 * (mem_total - mem_available) / mem_total))

vpn='OFF'
if timeout 1 nordvpn status 2>/dev/null | grep -q '^Status: Connected'; then
    vpn='ON'
fi

parts=("VPN:$vpn" "D:$(human_rate "$rx_rate")" "U:$(human_rate "$tx_rate")" "CPU:${cpu}%" "MEM:${mem}%")

if command -v nvidia-smi >/dev/null 2>&1; then
    gpu=$(timeout 1 nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1 | tr -d ' ')
    [[ $gpu =~ ^[0-9]+$ ]] && parts+=("GPU:${gpu}%")
fi

for battery in /sys/class/power_supply/BAT*; do
    if [[ -r $battery/capacity ]]; then
        capacity=$(<"$battery/capacity")
        parts+=("BAT:${capacity}%")
        break
    fi
done

uptime_seconds=$(awk '{ print int($1) }' /proc/uptime)
uptime_days=$((uptime_seconds / 86400))
uptime_hours=$(((uptime_seconds % 86400) / 3600))
if (( uptime_days > 0 )); then
    parts+=("UP:${uptime_days}d${uptime_hours}h")
else
    parts+=("UP:${uptime_hours}h")
fi

printf '%s' "${parts[0]}"
printf ' | %s' "${parts[@]:1}"
printf '\n'
