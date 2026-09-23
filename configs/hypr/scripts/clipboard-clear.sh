#!/bin/bash

# Очищаем всю историю буфера обмена
cliphist wipe

# Уведомление
hyprctl notify 2 2000 "rgb(FFF100)" "История буфера обмена очищена"
