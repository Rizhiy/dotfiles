#!/bin/bash

remote_id_list=$(
    xinput list |
    sed -n 's/.*Orbweaver.*id=\([0-9]*\).*keyboard.*/\1/p'
)

[ "$remote_id_list" ] || exit

for remote_id in $remote_id_list; do
mkdir -p /tmp/xkb/symbols
cat >/tmp/xkb/symbols/custom <<\EOF
xkb_symbols "remote" {
    key <LALT> {
        type= "ALPHABETIC",
        symbols[Group1]= [               g,               G ]
    };
    key <LFSH> {
        [           Alt_L,          Meta_L ]
    };
    key <CAPS> {
        [         Shift_L ]
    };
    key <AB01> {
        [       Control_L ]
    };
    modifier_map Control { <AB01> };

};
EOF

setxkbmap -device $remote_id -print | sed 's/\(xkb_symbols.*\)"/\1+custom(remote)"/' | xkbcomp -I/tmp/xkb -i $remote_id -synch - $DISPLAY 2>/dev/null
done

