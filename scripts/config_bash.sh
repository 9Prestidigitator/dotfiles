#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check
ensure_in_dir

# Adding config files
cp -f ./configs/tmux/.tmux.conf $HOME/.tmux.conf
cp -fr ./configs/fastfetch $HOME/.config/

# Installing custom ~/.bashrc
default_bashrc=$'#\n# ~/.bashrc\n#'
bashrc_header=$(head -n 3 $HOME/.bashrc || true)
if [[ "$default_bashrc" == "$bashrc_header" ]]; then
  bluetext "Default bashrc found, replacing with my own."
  customrc=$"#\n# ~/.bashrc (system)\n#\n\nif [[ -f "$HOME/dotfiles/.bashrc" ]]; then\n\tsource ~/dotfiles/.bashrc\nfi\n"
  cp $HOME/.bashrc $HOME/.bashrc.bak
  printf "%b" "$customrc" >$HOME/.bashrc
else
  echo -e "\nContains modular bashrc.\n"
fi

# Installing custom ~/.bash_profile
default_bash_prof=$'#\n# ~/.bash_profile\n#'
bash_prof_header=$(head -n 3 $HOME/.bash_profile || true)
if [[ "$default_bash_prof" == "$bash_prof_header" ]]; then
  bluetext "Default bash_profile found, replacing with my own."
  customprof=$"#\n# ~/.bash_profile (system)\n#\n\nif [[ -f "$HOME/dotfiles/.bashrc" ]]; then\n\tsource ~/dotfiles/.bash_profile\nfi\n"
  cp $HOME/.bash_profile $HOME/.bash_profile.bak
  printf "%b" "$customprof" >$HOME/.bash_profile
else
  echo -e "\nContains modular bash_profile.\n"
fi

# Installation of keyd, a really nice keyboard manager
prompt_run "Install keyd" pinn keyd && mkdir -p /etc/keyd && cp -f /.configs/keyd/default.conf /etc/keyd/default.conf

# Installing and configuring security packages
pinn ufw fail2ban openssh
sudo systemctl enable ufw

