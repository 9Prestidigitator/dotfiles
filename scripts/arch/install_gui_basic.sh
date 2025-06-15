#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh

sudo -v
pacupdate
ensure_in_dir

source $CONFIG_FILE

if [[ ${FileExplorer} == "on" ]]; then
  if [[ ${Dolphin} == "on" ]]; then
    pinn dolphin qt5ct qt6ct kvantum kvantum breeze-icons
    cp -fr ./configs/kde/dolphinrc $HOME/.config/dolphinrc
    cp -fr ./configs/kde/kdeglobals $HOME/.config/kdeglobals
    cp -fr ./configs/kde/kwalletrc $HOME/.config/kwalletrc
  fi
  [[ ${Nautilus} == "on" ]] && pinn nautilus
fi

if [[ ${Browser} == "on" ]]; then
  # Brave installation needs an aur helper
  ([[ -x "$(command -v paru)" ]] || [[ -x "$(command -v yay)" ]]) && [[ ${Brave} == "on" ]] && $(curl -fsS https://dl.brave.com/install.sh | sh)
  [[ ${Firefox} == "on" ]] && pinn firefox
  [[ ${Qute} == "on" ]] && pinn qutebrowser
fi
