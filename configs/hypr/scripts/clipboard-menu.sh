#!/bin/bash

if [ -z "$(cliphist list)" ]; then
    hyprctl notify 2 3000 "rgb(FFF100)" "История буфера пуста"
    exit 0
fi

# Формируем список с иконками
CHOICE=$(cliphist list | while read -r line; do
    id=$(echo "$line" | cut -f1)
    content=$(echo "$line" | cut -f2-)
    # Проверяем, картинка это или текст
    if echo "$content" | grep -q "image"; then
        echo -en "🖼️  $content\0icon\x1fimage-x-generic\n"
    else
        echo -en "📄  $content\0icon\x1ftext-x-generic\n"
    fi
done | rofi -dmenu -p "📋 Буфер обмена" -show-icons -theme ~/.config/rofi/clipboard.rasi)

if [ -n "$CHOICE" ]; then
    # Убираем иконку и пробелы
    CLEAN_CHOICE=$(echo "$CHOICE" | sed 's/^[^ ]*  //')
    echo "$CLEAN_CHOICE" | cliphist decode | wl-copy
    hyprctl notify 2 2000 "rgb(4CC9FE)" "Скопировано в буфер"
fi
