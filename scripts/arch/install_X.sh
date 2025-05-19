#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
source $CONFIG_FILE

sudo -v

./scripts/config_sl.sh

printf "\nConfiguring xinitrc...\n"
# Configure X11 startup
xinitrc="$HOME/.xinitrc"
source_line="source $DOTDIR/.xinitrc"
if [[ -f "$xinitrc" ]]; then
  if ! grep -Fxq "$source_line" "$xinitrc"; then
    printf "%s\n" "$source_line" >>"$xinitrc"
  fi
else
  printf "%s\n" "$source_line" >"$xinitrc"
fi

printf "\nInstalling dependencies...\n"
pinn libx11 xorg-server xorg-xinit xorg-xset libxft libxinerama xorgproto xorg-xrandr autorandr xorg-xev xf86-input-evdev xorg-xhost xclip slock maim feh picom dunst

# Picom is an effects compositor for X11
sudo cp -f ./configs/picom/picom.conf /etc/xdg/picom.conf

# dev/mixer is really old so got to load snd_pcm_oss module manually
sudo touch /etc/modules-load.d/modules.conf
echo "snd-pcm-oss" | sudo tee -a /etc/modules-load.d/modules.conf >/dev/null

# run build_sl script
./scripts/build_sl.sh

ensure_in_dir
