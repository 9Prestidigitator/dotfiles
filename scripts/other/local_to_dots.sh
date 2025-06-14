#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" && cd $script_dir/../..
source ./scripts/bash_functions.sh

auto="${1:-"no"}"

if [[ "$auto" != "auto" ]]; then
  prompt_run "Push local hyprland config?" cp -fr $HOME/.config/hypr ./configs/
else
  cp -fr $HOME/.config/hypr ./configs/
fi

if [[ "$auto" != "auto" ]]; then
  prompt_run "Push local waybar config?" cp -fr $HOME/.config/waybar ./configs/
else
  cp -fr $HOME/.config/waybar ./configs/
fi

if [[ "$auto" != "auto" ]]; then
  prompt_run "Push local wofi config?" cp -fr $HOME/.config/wofi ./configs/
else
  cp -fr $HOME/.config/wofi ./configs/
fi

if [[ "$auto" != "auto" ]]; then
  prompt_run "Push local alacritty config?" cp -fr $HOME/.config/alacritty ./configs/
else
  cp -fr $HOME/.config/alacritty ./configs/
fi

if [[ "$auto" != "auto" ]]; then
  prompt_run "Push local reaper config?" cp -fr $HOME/.config/REAPER ./configs/
else
  cp -fr $HOME/.config/REAPER ./configs/
fi
