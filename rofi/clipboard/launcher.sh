#!/usr/bin/env bash

if [[ -z $(wl-paste) ]]; then
  notify-send -u critical -t 4000 "Clipboard Manager" "Clipboard is empty"
  exit
fi

dir="$HOME/.config/rofi/clipboard"

choice=$(echo -e "\t\uf1f8   Wipe Clipboard\n$(cliphist list)" | rofi -markup-rows -dmenu -display-columns 2 -theme ${dir}/clipboard.rasi)

if [[ $choice == *"Wipe Clipboard"* ]]; then
  yes='yes'
  no='no'

  confirmation=$(echo -e "<span foreground='#a6e3a1'>$yes</span>\n<span foreground='#f38ba8'>$no</span>" |
    rofi -markup-rows -dmenu -p 'Confirmation' -mesg 'Are you Sure?' -theme ${dir}/confirmation.rasi)

  if [[ $confirmation =~ "$yes" ]]; then
    cliphist wipe
    wl-copy -c
    notify-send -u critical -t 4000 "Clipboard Manager" "Clipboard has been wiped"
  fi
  exit
elif [[ -n $choice ]]; then
  cliphist decode "$choice" | wl-copy
  wtype -M ctrl -M shift -P v -s 500 -p v -m shift -m ctrl
else
  exit
fi

