#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh

sudo -v
ensure_in_dir

pinn hyprland hyprpaper waybar wofi hyprlock wlr-randr wl-clipboard hypridle

cp -fr ./configs/hypr $HOME/.config && cp -fr ./configs/wofi $HOME/.config && cp -fr ./configs/waybar $HOME/.config

