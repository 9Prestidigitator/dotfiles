#!/bin/bash

set -e

# Define colors for scipt ricing
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
BOLD="\e[1m"
ULINE="\e[4m"
RESET="\033[0m"

sys_reboot() {
    read -p "$(echo -e "\n${BOLD}${YELLOW}Want to reboot? [(1) Yes, (0) No]: ${RESET}\n")" -n 1 -r reboot
    case $reboot in
        1)
            reboot;;
        *)
            echo -e "\nSkipping reboot.";;
        *)
            echo -e "\nInvalid input.";;
    esac
}

echo -e "\n${BLUE}${BOLD}Updating suckless programs...${RESET}"
echo -e "${YELLOW}Reboot required to take effect.${RESET}\n"

if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}${BOLD}This script requires root priveledges.${RESET}"
    sudo -v
fi

echo "Checking dependencies..."
pacman -S --noconfirm --needed base-devel git

read -p "$(echo -e "\n${GREEN}${BOLD}Build Suckless programs? [(1) Yes, (0) No]: ${RESET}\n")" -n 1 -r choice1
case $choice1 in
    1)
        echo "Checking dependencies..."
        # first three are the X11 packages, slock is a basic lock screen, feh is background manager, picom is effects manager
        pacman -S --noconfirm --needed libx11 libxft libxinerama xorgproto slock feh picom
        echo -e "\nBuilding sl programs.\n${GREEN}${BOLD}Building dwm.${RESET}\n"
        cd ./suckless/dwm/ && make clean install
        echo -e "\n${GREEN}${BOLD}Building dmenu.${RESET}\n"
        cd ../dmenu/ && make clean install
        echo -e "\n${GREEN}${BOLD}Building st.${RESET}\n"
        cd ../st && make clean install
        echo -e "\n${GREEN}${BOLD}Building slstatus.${RESET}\n"
        cd ../slstatus/ && make clean install
        cd ..;;
    0)
        echo -e "\nSkipping.";;
    *)
        echo -e "\nInvalid input";;
esac

sys_reboot

