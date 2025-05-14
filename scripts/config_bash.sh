#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check
ensure_in_dir

# Adding config files
cp -f ./.xinitrc /home/$SUDO_USER/.xinitrc
cp -f ./configs/tmux/.tmux.conf /home/$SUDO_USER/.tmux.conf
cp -fr ./configs/fastfetch /home/$SUDO_USER/.config/

# Installing custom ~/.bashrc
default_bashrc=$'#\n# ~/.bashrc\n#'
bashrc_header=$(head -n 3 /home/$SUDO_USER/.bashrc || true)
if [[ "$default_bashrc" == "$bashrc_header" ]]; then
  bluetext "Default bashrc found, replacing with my own."
  customrc=$"#\n# ~/.bashrc (system)\n#\n\nif [[ -f "/home/$SUDO_USER/dotfiles/.bashrc" ]]; then\n\tsource ~/dotfiles/.bashrc\nfi\n"
  cp /home/$SUDO_USER/.bashrc /home/$SUDO_USER/.bashrc.bak
  printf "%b" "$customrc" >/home/$SUDO_USER/.bashrc
else
  echo -e "\nContains modular bashrc.\n"
fi

# Installing custom ~/.bash_profile
default_bash_prof=$'#\n# ~/.bash_profile\n#'
bash_prof_header=$(head -n 3 /home/$SUDO_USER/.bash_profile || true)
if [[ "$default_bash_prof" == "$bash_prof_header" ]]; then
  bluetext "Default bash_profile found, replacing with my own."
  customprof=$"#\n# ~/.bash_profile (system)\n#\n\nif [[ -f "/home/$SUDO_USER/dotfiles/.bashrc" ]]; then\n\tsource ~/dotfiles/.bash_profile\nfi\n"
  cp /home/$SUDO_USER/.bash_profile /home/$SUDO_USER/.bash_profile.bak
  printf "%b" "$customprof" >/home/$SUDO_USER/.bash_profile
else
  echo -e "\nContains modular bash_profile.\n"
fi

