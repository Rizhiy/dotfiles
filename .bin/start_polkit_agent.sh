#!/usr/bin/env bash

# Minimal window-manager sessions do not start a graphical Polkit agent.
# Try the locations used by Arch and Debian/Ubuntu packages.
pgrep -u "$(id -u)" -f 'polkit-gnome-authentication-agent-1' >/dev/null && exit 0

for agent in \
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 \
    /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1
do
    if [[ -x "$agent" ]]; then
        exec "$agent"
    fi
done

printf 'No graphical Polkit authentication agent found\n' >&2
exit 1
