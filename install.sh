#!/bin/bash

set -e

sys_reboot() {
    read -p "Want to reboot? [(1) Yes, (0) No]: " -n 1 -r reboot
    case $reboot in
        1)
            reboot
            ;;
        *)
            echo "Skipping reboot."
            ;;
        *)
            echo "Invalid input."
            ;;
    esac
}

if [[ $EUID -ne 0 ]]; then
    echo "This script requires root priveledges."
    sudo -v
fi

echo "Updating system..."
pacman -Syu --noconfirm

echo "This Script requires GIT to be installed. Checking if GIT is installed..."
pacman -S --noconfirm --needed base-devel git

# Read function reads user input input a variable.
# -p adds a prompt, and -n adds a character limit.
read -p "Set up Window Manager (dwm)? [(1) Yes, (0) No]: " -n 1 -r choice1
echo -e "\n"
case $choice1 in
    1)
        echo "Installing dependencies..."
        # X11 packages, slock is a basic lock screen, feh is background manager, picom is effects manager
        pacman -S --noconfirm --needed xorg-server xorg-xinit libx11 libxft libxinerama xorgproto brightnessctl slock feh picom
        # Installing fonts
        pacman -S --noconfirm --needed ttf-jetbrains-mono noto-fonts-emoji
        # Installing other apps
        pacman -S --needed nautilus || true
        echo "Building sl programs."
        # build dwm
        cd ./suckless/dwm/
        make clean install
        # build dmenu
        cd ../dmenu/
        make clean install
        # build st
        cd ../st
        make clean install
        # build slstatus
        cd ../slstatus/
        make clean install

        cd ../..
        # Need to check if the line exists in the .bashrc exists in the file before appending
        # echo "[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx" >> ~/.bashrc
        cp -f ./.xinitrc /home/$SUDO_USER/.xinitrc
        ;;
    0)
        echo "Skipping."
        ;;
    *)
        echo "Invalid input"
        ;;
esac

# Install text editor: Alacritty
read -p "Install and configure Alacritty? [(1) Yes, (0) No]: " -n 1 -r alctty_choice
echo -e "\n"
case $alctty_choice in
    1)
        pacman -S --noconfirm alacritty
        mkdir -p ~/.config/nvim && cp -fr ./configs/alacritty /home/$SUDO_USER/.config/
        ;;
    0)
        echo "Skipping."
        ;;
    *)
        echo "Invalid input."
        ;;
esac

# Install text editor: Neovim
read -p "Install and configure NeoVIM? [(1) Yes, (0) No]: " -n 1 -r nvim_choice
echo -e "\n"
case $nvim_choice in
    1)
        pacman -S --noconfirm neovim npm python
        mkdir -p ~/.config/nvim && cp -fr ./configs/nvim /home/$SUDO_USER/.config/
        ;;
    0)
        echo "Skipping."
        ;;
    *)
        echo "Invalid input."
        ;;
esac

# Stuff to do other than troubleshooting:
# keyd
#

sys_reboot

