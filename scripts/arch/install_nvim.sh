#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check

pacman -S --noconfirm --needed neovim npm python
prompt_run "Install necessary latex packages?" pacman -S --needed --noconfirm zathura zathura-pdf-poppler texlive-core texlive-binextra texlive-science
cp -fr ./configs/nvim /home/$SUDO_USER/.config/
