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

echo -e "\n${BLUE}${ULINE}${BOLD}WELCOME TO MY DOTFILES INSTALL SCRIPT!${RESET}"
echo -e "${RED}Warning: This script is designed for a fresh isntall of Arch Linux.${RESET}\n"

if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}${BOLD}This script requires root priveledges.${RESET}"
    sudo -v
fi

echo -e "Updating system..."
pacman -Syu --noconfirm

echo -e "This Script requires GIT to be installed. Checking if GIT is installed..."
pacman -S --noconfirm --needed base-devel git

# Read function reads user input input a variable.
# -p adds a prompt, and -n adds a character limit.
read -p "$(echo -e "\n${GREEN}${BOLD}Set up Window Manager (dwm)? [(1) Yes, (0) No]: ${RESET}\n")" -n 1 -r sl_choice
case $sl_choice in
    1)
        echo -e "\nInstalling dependencies..."
        # X11 packages, slock is a basic lock screen, feh is background manager, picom is effects manager, starship is terminal assistant, keyd is keyboard manager
        pacman -S --noconfirm --needed xorg-server xorg-xinit libx11 libxft libxinerama xorgproto xorg-xrandr xorg-xev brightnessctl slock feh picom starship fastfetch keyd
        # Installing fonts
        pacman -S --noconfirm --needed ttf-jetbrains-mono ttf-jetbrains-mono-nerd noto-fonts-emoji
        # Installing audio stuff
        pacman -S --noconfirm --needed pavucontrol
        echo -e "\nBuilding sl programs.\n${GREEN}${BOLD}Building dwm.${RESET}\n"
        cd ./suckless/dwm/ && make clean install
        echo -e "\n${GREEN}${BOLD}Building dmenu.${RESET}\n"
        cd ../dmenu/ && make clean install
        echo -e "\n${GREEN}${BOLD}Building st.${RESET}\n"
        cd ../st && make clean install
        echo -e "\n${GREEN}${BOLD}Building slstatus.${RESET}\n"
        cd ../slstatus/ && make clean install
        # Adding config files
        cd ../..
        cp -f ./.bash_profile /home/$SUDO_USER/.bash_profile
        cp -f ./.bashrc /home/$SUDO_USER/.bashrc
        cp -f ./.xinitrc /home/$SUDO_USER/.xinitrc
        # These commands cause issues apparently
        # feh --bg-fill ./rice/wallpaper.jpg
        # cp -f /.configs/keyd/default.conf /etc/keyd/default.conf
        # cp -f ./configs/picom/picom.conf /etc/xdg/picom.conf
        ;;
    0)
        echo -e "Skipping.";;
    *)
        echo -e "Invalid input";;
esac

# Install text editor: Alacritty
read -p "$(echo -e "\n${GREEN}${BOLD}Install and configure Alacritty? [(1) Yes, (0) No]: ${RESET}\n")" -n 1 -r alctty_choice
case $alctty_choice in
    1)
        pacman -S --noconfirm alacritty
        mkdir -p ~/.config/nvim && cp -fr ./configs/alacritty /home/$SUDO_USER/.config/;;
    0)
        echo -e "\nSkipping.";;
    *)
        echo -e "\nInvalid input.";;
esac

# Install text editor: Neovim
read -p "$(echo -e "\n${GREEN}${BOLD}Install and configure NeoVIM? [(1) Yes, (0) No]: ${RESET}\n")" -n 1 -r nvim_choice
case $nvim_choice in
    1)
        pacman -S --noconfirm neovim npm python
        mkdir -p ~/.config/nvim && cp -fr ./configs/nvim /home/$SUDO_USER/.config/;;
    0)
        echo -e "\nSkipping.";;
    *)
        echo -e "\nInvalid input.";;
esac

# Other apps
read -p "$(echo -e "\n${GREEN}${BOLD}Do you want to install other GUI applications? [(1) Yes, (0) No]: ${RESET}\n")" -n 1 -r apps_choice
case $apps_choice in
    1)
        pacman -S --needed firefox || true
        pacman -S --needed nautilus || true;;
    0)
        echo -e "\nSkipping.";;
    *)
        echo -e "\nInvalid input.";;
esac

# Bonus: Install Virtual Machine: QEMU/KVM
read -p "$(echo -e "\n${GREEN}${BOLD}Do you want to install VM (QEMU/KVM)? [(1) Yes, (0) No]: ${RESET}\n")" -n 1 -r VM_choice
case $VM_choice in
    1)
        pacman -S --needed qemu-full qemu-img libvirt virt-install virt-manager virt-viewer edk2-ovmf dnsmasq swtpm guestfs-tools libosinfo tuned || true;;
        systemctl enable libvirtd.service
    0)
        echo -e "\nSkipping.";;
    *)
        echo -e "\nInvalid input.";;
esac

sys_reboot

