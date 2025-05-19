#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

sudo -v

echo -e "\nBuilding sl programs.\n${GREEN}${BOLD}Building dwm.${RESET}\n"
cd ./suckless/dwm/ && sudo make clean install
printf "\nBuilding dmenu.\n"
cd ../dmenu/ && sudo make clean install
printf "\nBuilding st.\n"
cd ../st && sudo make clean install
printf "\nBuilding slstatus.\n"
cd ../slstatus/ && sudo make clean install && cd ../..
printf "\nReboot required to take effect.\n"
