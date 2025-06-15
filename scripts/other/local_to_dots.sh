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
  printf "Copied hyprland configuration files to dots...\n"
fi

if [[ "$auto" != "auto" ]]; then
  prompt_run "Push local waybar config?" cp -fr $HOME/.config/waybar ./configs/
else
  cp -fr $HOME/.config/waybar ./configs/
  printf "Copied waybar configuration files to dots...\n"
fi

if [[ "$auto" != "auto" ]]; then
  prompt_run "Push local wofi config?" cp -fr $HOME/.config/wofi ./configs/
else
  cp -fr $HOME/.config/wofi ./configs/
  printf "Copied wofi configuration files to dots...\n"
fi

if [[ "$auto" != "auto" ]]; then
  prompt_run "Push local alacritty config?" cp -fr $HOME/.config/alacritty ./configs/
else
  cp -fr $HOME/.config/alacritty ./configs/
  printf "Copied alacritty configuration files to dots...\n"
fi

if [[ "$auto" != "auto" ]]; then
  prompt_run "Push local reaper config?" cp -fr $HOME/.config/REAPER ./configs/
else
  cp -fr $HOME/.config/REAPER ./configs/
  printf "Copied reaper configuration files to dots...\n"
fi

if [[ "$auto" != "auto" ]]; then
  prompt_run "Push local dunst config?" cp -fr $HOME/.config/dunst ./configs/
else
  cp -fr $HOME/.config/dunst ./configs/
  printf "Copied dunst configuration files to dots...\n"
fi

if [[ "$auto" != "auto" ]]; then
  prompt_run "Push local fastfetch config?" cp -fr $HOME/.config/fastfetch ./configs/
else
  cp -fr $HOME/.config/fastfetch ./configs/
  printf "Copied fastfetch configuration files to dots...\n"
fi

