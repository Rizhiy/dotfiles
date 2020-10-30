#!/bin/bash

. "$HOME/.local/share/multilockscreen/multilockscreen" --lock -- --layoutpos='ix-90:iy-0' --layout-align 1 --layoutcolor=ffffffff --keylayout 2 & sleep 1 && xset dpms force off
