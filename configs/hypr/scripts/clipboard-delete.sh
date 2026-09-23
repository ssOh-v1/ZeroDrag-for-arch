#!/bin/bash

# Проверяем, есть ли история
if [ -z "$(cliphist list)" ]; then
    hyprctl notify 2 3000 "rgb(FFF100)" "История буфера пуста"
    exit 0
fi

# Показываем меню с теми же стилями, что и для копирования
CHOICE=$(cliphist list | rofi -dmenu -p "🗑️ Удалить из буфера" -theme ~/.config/rofi/clipboard.rasi)

# Если выбрали — удаляем
if [ -n "$CHOICE" ]; then
    ID=$(echo "$CHOICE" | cut -f1)
    cliphist delete "$ID"
    hyprctl notify 2 2000 "rgb(4CC9FE)" "Элемент удалён"
fi
