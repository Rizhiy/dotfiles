#!/bin/bash

remote_id_list=$(
    xinput list |
    sed -n 's/.*Orbweaver.*id=\([0-9]*\).*keyboard.*/\1/p'
)

[ "$remote_id_list" ] || exit

for remote_id in $remote_id_list; do
	setxkbmap -device $remote_id -print | sed 's/\(xkb_symbols.*\)"/\1+custom(remote)"/' | xkbcomp -I"$HOME"/.xkb -i $remote_id -synch - $DISPLAY 2>/dev/null
done

