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

detect_project_type() {
    if [[ -f "$selected/pyproject.toml" ]]; then
        echo "python"
    elif [[ -f "$selected/Cargo.toml" ]]; then
        echo "rust"
    else
        echo "Could not detect project type for $selected" >&2
        echo -e "python\nrust" | fzf --prompt="Select project type: "
    fi
}

new_window_cmd() {
    project_type=$(detect_project_type)

    if [[ $project_type == "python" ]]; then
        tmux send-keys -t main:$selected_name "cd $selected; act; vim; clear" C-m
    else
        tmux send-keys -t main:$selected_name "cd $selected; vim; clear" C-m
    fi
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
