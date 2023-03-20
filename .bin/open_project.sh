#!/bin/bash

# Based on ThePrimeagen's tmux-sessionizer, but using windows instead of sessions

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/projects -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

new_window_cmd() {
    tmux send-keys -t main:$selected_name "cd $selected; act; vim; clear" C-m
}

if [[ -z $tmux_running ]] || ! tmux has-session -t main:$selected_name 2>/dev/null; then
    tmux new-session -d -s main -n $selected_name || tmux new-window -t main -n $selected_name
    new_window_cmd
fi

if [[ -z $TMUX ]]; then
    tmux a -t main:$selected_name
else
    tmux switch-client -t main:$selected_name 2>/dev/null
fi
