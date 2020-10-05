#!/bin/bash

bluetooth_print() {
    if bluetoothctl show | grep -q "Powered: yes"; then
        devices_paired=$(bluetoothctl paired-devices | grep Device | cut -d ' ' -f 2)
        str=""

        while read -r line; do
            device_info=$(bluetoothctl info "$line")

            if echo "$device_info" | grep -q "Connected: yes"; then
                device_alias=$(echo "$device_info" | grep "Alias" | cut -d ' ' -f 2-)

                if [ "$str" = "" ]; then
                    str=" $device_alias"
                else
                    str="$str, $device_alias"
                fi

                counter=$((counter + 1))
            fi
        done <<< "$devices_paired"


        if [ "$str" = "" ]; then
            str=""
        fi

        echo "$str"
    else
        echo ""
    fi
}

bluetooth_toggle() {
    if bluetoothctl show | grep -q "Powered: no"; then
        bluetoothctl power on >> /dev/null
        sleep 1

        devices_paired=$(bluetoothctl paired-devices | grep Device | cut -d ' ' -f 2)
        echo "$devices_paired" | while read -r line; do
            bluetoothctl connect "$line" >> /dev/null
        done
    else
        devices_paired=$(bluetoothctl paired-devices | grep Device | cut -d ' ' -f 2)
        echo "$devices_paired" | while read -r line; do
            bluetoothctl disconnect "$line" >> /dev/null
        done

        bluetoothctl power off >> /dev/null
    fi
}

case "$1" in
    --toggle)
        bluetooth_toggle
        ;;
    *)
        bluetooth_print
        ;;
esac
