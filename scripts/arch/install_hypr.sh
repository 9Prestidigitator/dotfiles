#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh

sudo -v
ensure_in_dir

pinn hyprland hyprpaper waybar wofi hyprlock wlr-randr wl-clipboard hypridle qt5-wayland qt6-wayland xdg-desktop-portal-hyprland wev

[[ -x "$(command -v paru)" ]] && paru -S --noconfirm grimblast
[[ -x "$(command -v paru)" ]] && paru -S --noconfirm swayosd-git

cp -fr ./configs/hypr $HOME/.config && cp -fr ./configs/wofi $HOME/.config && cp -fr ./configs/waybar $HOME/.config

