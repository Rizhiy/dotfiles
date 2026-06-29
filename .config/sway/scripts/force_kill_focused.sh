#!/bin/sh

pid=$(swaymsg -t get_tree | jq -r '.. | objects | select(.focused == true) | .pid // empty')

if [ -z "$pid" ] || [ "$pid" = "null" ]; then
  exit 1
fi

kill -KILL "$pid"
