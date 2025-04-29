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

# Reboot system
sys_reboot() {
  read -p "$(echo -e "\n${BOLD}${YELLOW}Want to reboot? [(1) Yes, (0) No]: ${RESET}\n")" -n 1 -r reboot
  case $reboot in
  1)
    reboot
    ;;
  *)
    echo -e "\nSkipping reboot."
    ;;
  *)
    echo -e "\nInvalid input."
    ;;
  esac
}

# Generate bold green user prompt
prompt() {
  local text="$1"
  local user_input
  read -p "$(echo -en "\n${GREEN}${BOLD}$text ${RESET}\n")" -rn 1 user_input
  echo "$user_input"
}

prompt_run() {
  local text="$1"
  shift
  local cmd="$@"
  read -p "$(echo -en "\n${GREEN}${BOLD}$text [y/n]: ${RESET}\n")" -n 1 -r user_input
  if [[ "$user_input" =~ ^[Yy]$ ]]; then
    eval "$cmd"
    echo "1"
  else
    echo -en "\nAborted.\n"
    echo "0"
  fi
}

boldbluetext() {
  local text="$1"
  echo -en "\n${BLUE}${BOLD}$text ${RESET}\n"
}

root_check() {
  if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}${BOLD}This script requires root priveledges.${RESET}"
    sudo -v
  fi
}
