#!/usr/bin/env bash

# Project picker for Herdr. Each project gets one workspace.
set -u

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find "$HOME/projects" -mindepth 1 -maxdepth 1 -type d | sort | fzf)
fi

[[ -n ${selected:-} ]] || exit 0
selected=$(realpath "$selected")
selected_name=$(basename "$selected" | tr . _)

server_running() {
    herdr status server 2>/dev/null | grep -q '^status: running$'
}

started_server=false
if ! server_running; then
    nohup herdr server >"${XDG_RUNTIME_DIR:-/tmp}/herdr-server-startup.log" 2>&1 &
    started_server=true
    for _ in {1..50}; do
        server_running && break
        sleep 0.1
    done
fi

if ! server_running; then
    printf 'Could not start the Herdr server\n' >&2
    exit 1
fi

workspace_id=$(
    herdr workspace list |
        jq -r --arg label "$selected_name" \
            '.result.workspaces[] | select(.label == $label) | .workspace_id' |
        head -n1
)

if [[ -z $workspace_id ]]; then
    response=$(herdr workspace create --cwd "$selected" --label "$selected_name" --focus)
    workspace_id=$(jq -r '.result.workspace.workspace_id' <<<"$response")
    pane_id=$(jq -r '.result.root_pane.pane_id' <<<"$response")

    printf -v quoted_project '%q' "$selected"
    if [[ -f $selected/pyproject.toml ]]; then
        command="cd $quoted_project; act; nvim; clear"
    else
        command="cd $quoted_project; nvim; clear"
    fi
    herdr pane run "$pane_id" "$command" >/dev/null
else
    herdr workspace focus "$workspace_id" >/dev/null
fi

# Outside Herdr, attach after preparing and focusing the requested workspace.
if [[ ${HERDR_ENV:-0} != 1 ]]; then
    exec herdr
fi

# A popup invocation closes on exit and reveals the newly focused workspace.
$started_server && disown || true
