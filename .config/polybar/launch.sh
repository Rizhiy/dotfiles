#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

polybar "top" 2>&1 & disown
polybar "bottom" 2>&1 & disown

