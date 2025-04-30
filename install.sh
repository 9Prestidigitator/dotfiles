#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check
pacupdate
gitupdate
ensure_in_dir

echo -e "\n${BLUE}${ULINE}${BOLD}WELCOME TO MY DOTFILES INSTALL SCRIPT!${RESET}"
echo -e "${RED}Warning: This script is designed for a fresh isntall of Arch Linux.${RESET}\n"

# Install main editor: Neovim
nvim=$(prompt_run "Configure NeoVIM?" ./scripts/arch/install_nvim.sh)
# Install X11/dwm
dwm_build=$(prompt_run "Install X11/dwm?" ./scripts/arch/install_X.sh)

# Need some sort of display server for best experience:
if [[ $dwm_build -eq 1 ]]; then
  # Install terminal emulator: Alacritty
  prompt_run "Configure and install Alacritty?" ./scripts/arch/install_alacritty.sh
  # Install basic gui applications
  prompt_run "Install basic GUI applications?" ./scripts/arch/install_gui_basic.sh
  # Install DAW and other audio packages
  prompt_run "Install audio production packages?" ./scripts/arch/audio.sh
  # Bonus: Install Virtual Machine: QEMU/KVM
  prompt_run "Do you want to install VM (QEMU/KVM)?" ./scripts/arch/qemuKVM.sh
fi

sys_reboot
