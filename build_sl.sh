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

echo "Checking dependencies..."
pacman -S --noconfirm --needed base-devel git

read -p "Build Suckless programs? [(1) Yes, (0) No]: " -n 1 -r choice1
echo -e "\n"
case $choice1 in
    1)
        echo "Checking dependencies..."
        # first three are the X11 packages, slock is a basic lock screen, feh is background manager, picom is effects manager
        pacman -S --noconfirm --needed libx11 libxft libxinerama xorgproto slock feh picom
        echo "Building sl programs."
        # build dwm
        cd ./suckless/dwm/
        make clean install
        echo -e "\n"
        # build dmenu
        cd ../dmenu/
        make clean install
        echo -e "\n"
        # build st
        cd ../st
        make clean install
        echo -e "\n"
        # build slstatus
        cd ../slstatus/
        make clean install
        echo -e "\n"

        cd ..
        ;;
    0)
        echo "Skipping."
        ;;
    *)
        echo "Invalid input"
        ;;
esac

sys_reboot

