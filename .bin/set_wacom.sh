#!/bin/bash

#check if monitor number was given
if test -z "$1" ; then
  #no monitor number was given, use the main display
  MON_NO=0
else
  MON_NO=$1
fi

#for each id of wacom devices set correct output monitor
xsetwacom list devices |
while IFS= read -r line; do
  #get id of wacom device in line
  WACOM_ID="$(echo $line | sed 's/.*id: //' | cut -d " " -f 1)"
  #set monitor as output
  xsetwacom --set $WACOM_ID MapToOutput HEAD-$MON_NO
done

echo "Changed monitor for all wacom devices."
