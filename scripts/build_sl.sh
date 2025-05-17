#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/bash_functions.sh
root_check

echo -e "\nBuilding sl programs.\n${GREEN}${BOLD}Building dwm.${RESET}\n"
cd ./suckless/dwm/ && make clean install
echo -e "\n${GREEN}${BOLD}Building dmenu.${RESET}\n"
cd ../dmenu/ && make clean install
echo -e "\n${GREEN}${BOLD}Building st.${RESET}\n"
cd ../st && make clean install
echo -e "\n${GREEN}${BOLD}Building slstatus.${RESET}\n"
cd ../slstatus/ && make clean install && cd ../..
echo -e "\n${YELLOW}Reboot required to take effect.${RESET}\n"
