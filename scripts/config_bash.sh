#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check
ensure_in_dir

# Adding config files
cp -f ./.xinitrc /home/$SUDO_USER/.xinitrc
cp -fr ./configs/fastfetch /home/$SUDO_USER/.config/

default_bashrc=$'#\n# ~/.bashrc\n#'
bashrc_header=$(head -n 3 /home/$SUDO_USER/.bashrc || true)

if [[ "$default_bashrc" == "$bashrc_header" ]]; then
  bluetext "default bashrc found, replacing with my own."
  customrc=$"#\n# ~/.bashrc (system)\n#\n\nif [[ -f "/home/$SUDO_USER/dotfiles/.bashrc" ]]; then\nsource~/dotfiles/.bashrc\nfi\n"

  cp /home/$SUDO_USER/.bashrc /home/$SUDO_USER/.bashrc.bak
  printf "%b" "$customrc" > /home/$SUDO_USER/.bashrc
fi

cp -f ./.bash_profile /home/$SUDO_USER/.bash_profile
# cp -f ./.bashrc /home/$SUDO_USER/.bashrc
