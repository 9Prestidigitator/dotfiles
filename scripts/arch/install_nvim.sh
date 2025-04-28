#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check

latexinstall="${1:-$(prompt "Install necessary latex packages? (1/0)")}"

pacman -S --noconfirm neovim npm python
# These packages are needed for latex editing
if [[ $latexinstall eq 1 ]]; then
  pacman -S zathura zathura-pdf-poppler texlive-core texlive-binextra texlive-science
fi
mkdir -p ~/.config/nvim && cp -fr ./configs/nvim /home/$SUDO_USER/.config/
