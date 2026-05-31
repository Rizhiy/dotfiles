#!/usr/bin/env bash
set -euo pipefail

choice=$(printf '%s\n' \
    '  lock screen' \
    '󰗼  log out' \
    '  suspend' \
    '󰒲  hibernate' \
    '  reboot' \
    '  shut down' \
    | wofi \
        --dmenu \
        --prompt 'Power menu' \
        --width 50% \
        --height 50% \
        --style "$HOME/.config/sway/wofi-keybindings.css" \
        --gtk-dark-theme \
        --insensitive)

choice=${choice#*  }

case "$choice" in
    'lock screen')
        loginctl lock-session "${XDG_SESSION_ID:-}"
        ;;
    'log out')
        if [[ $(printf 'No\nYes\n' | wofi --dmenu --prompt 'Log out?' --width 50% --height 50% --style "$HOME/.config/sway/wofi-keybindings.css" --gtk-dark-theme --insensitive) = 'Yes' ]]; then
            swaymsg exit
        fi
        ;;
    'suspend')
        systemctl suspend
        ;;
    'hibernate')
        systemctl hibernate
        ;;
    'reboot')
        if [[ $(printf 'No\nYes\n' | wofi --dmenu --prompt 'Reboot?' --width 50% --height 50% --style "$HOME/.config/sway/wofi-keybindings.css" --gtk-dark-theme --insensitive) = 'Yes' ]]; then
            systemctl reboot
        fi
        ;;
    'shut down')
        if [[ $(printf 'No\nYes\n' | wofi --dmenu --prompt 'Shut down?' --width 50% --height 50% --style "$HOME/.config/sway/wofi-keybindings.css" --gtk-dark-theme --insensitive) = 'Yes' ]]; then
            systemctl poweroff
        fi
        ;;
esac
