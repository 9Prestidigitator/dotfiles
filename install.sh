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

install_aur() {
    local aur_pkg = "$1"
    if ! yay -Qi "$aur_pkg" &> /dev/null; then
        echo "Installing $aur_pkg from AUR..."
        yay -S --noconfirm --needed "$aur_pkg"
    else
        echo "$aur_pkg is already installed."
    fi
}

if [[ $EUID -ne 0 ]]; then
    echo "This script requires root priveledges."
    sudo -v
fi

echo "This Script requires GIT to be installed. Checking if GIT is installed..."
pacman -S --noconfirm --needed base-devel git
echo "Updating system..."
pacman -Syu

# Install text editor: Neovim
read -p "Install and configure NeoVIM? [(1) Yes, (0) No]: " -n 1 -r nvim_choice
echo -e "\n"
case $nvim_choice in
    1)
        pacman -S neovim npm
        cp -rT ./nvim ~/.config/nvim
        ;;
    0)
        echo "Skipping."
        ;;
    *)
        echo "Invalid input."
        ;;
esac

# Install AUR manager
read -p "Install AUR manager? [(2) paru, (1) yay, (0) No]: " -n 1 -r AUR_choice
echo -e "\n"
case $AUR_choice in
    2)
        git clone https://aur.archlinux.org/paru.git
        cd paru
        sudo -u makepkg -si
        cd ..
        rm -rf ./paru
        ;;
    1)
        git clone https://aur.archlinux.org/yay.git
        cd yay
        sudo -u makepkg -si
        cd ..
        rm -rf ./yay
        ;;
    0)
        echo "Skipping."
        ;;
esac

# Read function reads user input input a variable.
# -p adds a prompt, and -n adds a character limit.
read -p "Set up Window Manager (dwm)? [(1) Yes, (0) No]: " -n 1 -r choice1
echo -e "\n"
case $choice1 in
    1)
        echo "Installing dependencies..."
        # X11 packages, slock is a basic lock screen, feh is background manager, picom is effects manager
        pacman -S --needed xorg-server xorg-xinit libx11 libxft libxinerama xorgproto slock feh picom
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
        cp -f ./.xinitrc ~/.xinitrc
        ;;
    0)
        echo "Skipping."
        ;;
    *)
        echo "Invalid input"
        ;;
esac

sys_reboot

