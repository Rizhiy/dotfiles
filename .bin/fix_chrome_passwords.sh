#!/usr/bin/env bash

read -p "This will restart chrome. Are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit
fi

killall chrome

# Taken from https://unix.stackexchange.com/questions/538482/chrome-does-not-save-my-passwords
cd ~/.config/google-chrome/Default
rm 'Login Data'
rm 'Login Data-journal'

nohup google-chrome &>/dev/null &
