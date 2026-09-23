#!/bin/bash

# ZeroDrag-for-arch — установка окружения
# Автор: ssOh-v1

set -e

echo "=== ZeroDrag-for-arch: установка ==="

# 1. Проверка, что мы на Arch
if ! command -v pacman &>/dev/null; then
    echo "Ошибка: этот скрипт только для Arch Linux и производных."
    exit 1
fi

# 2. Установка пакетов
echo "=== Установка пакетов ==="
sudo pacman -S --needed --noconfirm \
    hyprland hyprpaper hyprlock hypridle hyprpolkitagent \
    xdg-desktop-portal-hyprland \
    waybar rofi kitty swaync cliphist fastfetch \
    sddm qt6-5compat qt6-shadertools qt6-declarative \
    pipewire pipewire-pulse pipewire-alsa wireplumber \
    pavucontrol network-manager-applet blueman \
    ttf-fredoka noto-fonts noto-fonts-emoji

# 3. Установка AUR-пакетов (если есть yay)
if command -v yay &>/dev/null; then
    echo "=== Установка AUR-пакетов ==="
    yay -S --needed --noconfirm wallust matugen 2>/dev/null || true
fi

# 4. Копирование конфигов
echo "=== Копирование конфигов ==="
mkdir -p ~/.config
cp -r configs/hypr ~/.config/
cp -r configs/waybar ~/.config/
cp -r configs/rofi ~/.config/
cp -r configs/kitty ~/.config/
cp -r configs/swaync ~/.config/
cp -r configs/fastfetch ~/.config/

# 5. Копирование скриптов
echo "=== Копирование скриптов ==="
mkdir -p ~/.local/bin
cp scripts/* ~/.local/bin/
chmod +x ~/.local/bin/*

# 6. Установка обоев
echo "=== Установка обоев ==="
sudo mkdir -p /usr/share/sddm/themes/ii-sddm-theme/Backgrounds
sudo cp -n wallpapers/* /usr/share/sddm/themes/ii-sddm-theme/Backgrounds/ 2>/dev/null || true

# 7. Включение SDDM
echo "=== Включение SDDM ==="
sudo systemctl enable sddm

echo ""
echo "=== Установка завершена! ==="
echo "Перезагрузитесь: sudo reboot"
