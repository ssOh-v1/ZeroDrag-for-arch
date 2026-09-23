#!/bin/bash

# ZeroDrag-for-arch — установка окружения
# Автор: ssOh-v1

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== ZeroDrag-for-arch: установка ===${NC}"

# 1. Проверка, что мы на Arch
if ! command -v pacman &>/dev/null; then
    echo -e "${RED}Ошибка: этот скрипт только для Arch Linux и производных.${NC}"
    exit 1
fi

# 2. Установка пакетов
echo -e "${YELLOW}=== Установка пакетов ===${NC}"
sudo pacman -S --needed --noconfirm \
    hyprland hyprpaper hyprlock hypridle hyprpolkitagent \
    xdg-desktop-portal-hyprland \
    waybar rofi kitty swaync cliphist fastfetch \
    sddm qt6-5compat qt6-shadertools qt6-declarative \
    pipewire pipewire-pulse pipewire-alsa wireplumber \
    pavucontrol network-manager-applet blueman \
    ttf-fredoka noto-fonts noto-fonts-emoji \
    fuzzel wl-clipboard grim slurp

# 3. Установка AUR-пакетов (если есть yay)
if command -v yay &>/dev/null; then
    echo -e "${YELLOW}=== Установка AUR-пакетов ===${NC}"
    yay -S --needed --noconfirm wallust matugen 2>/dev/null || true
else
    echo -e "${YELLOW}yay не найден, пропускаем AUR-пакеты${NC}"
fi

# 4. Копирование конфигов
echo -e "${YELLOW}=== Копирование конфигов ===${NC}"
mkdir -p ~/.config
cp -r configs/hypr ~/.config/
cp -r configs/waybar ~/.config/
cp -r configs/rofi ~/.config/
cp -r configs/kitty ~/.config/
cp -r configs/swaync ~/.config/
cp -r configs/fastfetch ~/.config/

# 5. Копирование скриптов
echo -e "${YELLOW}=== Копирование скриптов ===${NC}"
mkdir -p ~/.local/bin
cp scripts/* ~/.local/bin/ 2>/dev/null || true
chmod +x ~/.local/bin/* 2>/dev/null || true

# 6. Установка обоев
echo -e "${YELLOW}=== Установка обоев ===${NC}"
sudo mkdir -p /usr/share/sddm/themes/ii-sddm-theme/Backgrounds
sudo cp -n wallpapers/* /usr/share/sddm/themes/ii-sddm-theme/Backgrounds/ 2>/dev/null || true

# 7. Настройка sudoers для смены обоев без пароля
echo -e "${YELLOW}=== Настройка sudoers ===${NC}"
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/cp" | sudo tee /etc/sudoers.d/wallpaper-change > /dev/null
sudo chmod 440 /etc/sudoers.d/wallpaper-change

# 8. Включение SDDM
echo -e "${YELLOW}=== Включение SDDM ===${NC}"
sudo systemctl enable sddm

echo ""
echo -e "${GREEN}=== Установка завершена! ===${NC}"
echo -e "${GREEN}Перезагрузитесь: sudo reboot${NC}"
