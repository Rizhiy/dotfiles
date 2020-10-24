#!/bin/bash
# Create config file with monitors
find_monitors() {
	IFS=' '; numbers=($(xrandr | grep "DP.* connected" | cut -d ' ' -f1 | tr '\n' ' '))
	printf "monitor_left: ${numbers[0]}\nmonitor_right: ${numbers[1]}" > .local/share/monitors.yaml
}
find_monitors
