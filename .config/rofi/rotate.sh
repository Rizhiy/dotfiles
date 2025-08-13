#!/usr/bin/env bash

output=$(swaymsg -t get_outputs | jq -r ".[] | select(.focused) | .name");
current=$(swaymsg -t get_outputs | jq -r ".[] | select(.name==\"$output\") | .transform");
if [ "$current" = "normal" ]; then
    swaymsg output "$output" transform 270;
else
    swaymsg output "$output" transform normal;
fi
