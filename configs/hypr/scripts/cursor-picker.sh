#!/bin/bash

CURSOR_DIRS=("$HOME/.icons" "$HOME/.local/share/icons" "/usr/share/icons")

mapfile -t THEMES < <(find "${CURSOR_DIRS[@]}" -maxdepth 2 -type d -name "cursors" 2>/dev/null | sed 's|/cursors$||' | xargs -n 1 basename | sort -u)

CHOICE=$(printf "%s\n" "${THEMES[@]}" | rofi -dmenu -p "Курсор" -theme ~/.config/rofi/theme-picker.rasi)

if [ -n "$CHOICE" ]; then
    hyprctl setcursor "$CHOICE" 24
    gsettings set org.gnome.desktop.interface cursor-theme "$CHOICE"
    notify-send "Курсор" "Установлен: $CHOICE"
fi
