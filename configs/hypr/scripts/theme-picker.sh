#!/bin/bash

# Папки, где искать курсоры
CURSOR_DIRS=("$HOME/.icons" "$HOME/.local/share/icons" "/usr/share/icons")

# Получаем список курсоров
mapfile -t CURSORS < <(find "${CURSOR_DIRS[@]}" -maxdepth 2 -type d -name "cursors" 2>/dev/null | sed 's|/cursors$||' | xargs -n 1 basename | sort -u)

# Получаем список шрифтов
mapfile -t FONTS < <(fc-list : family | sort -u)

# Объединяем в один список с метками
{
    for cursor in "${CURSORS[@]}"; do
        echo -en "🖱️  $cursor\0icon\x1f$HOME/.icons/$cursor/cursors/default\n"
    done
    for font in "${FONTS[@]}"; do
        echo "🔤  $font"
    done
} | rofi -dmenu -p "Курсор / Шрифт" -show-icons -theme ~/.config/rofi/theme-picker.rasi | while read -r choice; do
    # Убираем эмодзи и пробелы
    choice=$(echo "$choice" | sed 's/^[^ ]*  //')
    
    if [[ " ${CURSORS[@]} " =~ " ${choice} " ]]; then
        # Это курсор
        hyprctl setcursor "$choice" 24
        gsettings set org.gnome.desktop.interface cursor-theme "$choice"
        notify-send "Курсор" "Установлен: $choice"
    else
        # Это шрифт
        gsettings set org.gnome.desktop.interface font-name "$choice 11"
        notify-send "Шрифт" "Установлен: $choice"
    fi
done
