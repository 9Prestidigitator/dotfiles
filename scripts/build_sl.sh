#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/bash_functions.sh

sudo -v

echo -e "\nBuilding sl programs.\n${GREEN}${BOLD}Building dwm.${RESET}\n"
cd ./suckless/dwm/ && sudo make clean install
echo -e "\n${GREEN}${BOLD}Building dmenu.${RESET}\n"
cd ../dmenu/ && sudo make clean install
echo -e "\n${GREEN}${BOLD}Building st.${RESET}\n"
cd ../st && sudo make clean install
echo -e "\n${GREEN}${BOLD}Building slstatus.${RESET}\n"
cd ../slstatus/ && sudo make clean install && cd ../..
echo -e "\n${YELLOW}Reboot required to take effect.${RESET}\n"
