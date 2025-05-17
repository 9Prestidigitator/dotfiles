#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check
pacupdate

source $CONFIG_FILE

if [[ ${FileExplorer} == "on" ]]; then
  [[ ${Dolphin} == "on" ]] && pinn dolphin
  [[ ${Nautilus} == "on" ]] && pinn nautilus
fi

if [[ ${Browser} == "on" ]]; then
  # Brave installation needs an aur helper
  [[ ${AURHelperparu} == "on" ]] && [[ ${Brave} == "on" ]] && curl -fsS https://dl.brave.com/install.sh | sh
  [[ ${Firefox} == "on" ]] && pinn firefox
  [[ ${Qute} == "on" ]] && pinn qutebrowser
fi

# browser="${1:-$(prompt "Choose your browser: \nBrave(1)\nFirefox(2)\nQutebrowser(3)")}"
# fileexplorer="${2:-$(prompt "Choose your file explorer: \nNautilus(1)\nDolphin(2)")}"

# # browser=prompt "Choose your browser: \nBrave(1)\nFirefox(2)\nQutebrowser(3)"
# if [[ $browser -eq 1 ]]; then
#   curl -fsS https://dl.brave.com/install.sh | sh
# elif [[ $browser -eq 2 ]]; then
#   pacman -S --noconfirm --needed firefox || true
# elif [[ $browser -eq 2 ]]; then
#   pacman -S --noconfirm --needed qutebrowser || true
# fi
# if [[ $fileexplorer -eq 1 ]]; then
#   pacman -S --noconfirm --needed nautilus || true
# elif [[ $fileexplorer -eq 2 ]]; then
#   pacman -S --noconfirm --needed dolphin || true
# fi
