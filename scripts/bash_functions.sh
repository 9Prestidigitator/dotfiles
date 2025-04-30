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

ensure_in_dir() {
  local target_dir="${1:-"/home/$SUDO_USER/dotfiles/"}"
  # Expand ~ to full home path
  target_dir="${target_dir/#\~/$HOME}"
  # Resolve both paths to avoid mismatch from symlinks, etc.
  local current_dir
  current_dir="$(realpath "$PWD")"
  local resolved_target
  resolved_target="$(realpath "$target_dir")"
  if [[ "$current_dir" != "$resolved_target" ]]; then
    greentext "Changing directory to: $resolved_target"
    cd "$resolved_target" || {
      redtext "Error: Could not change to $resolved_target"
      return 1
    }
  else
  fi
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
    eval "$cmd" >&2
    echo "1"
  else
    echo -en "\nAborted.\n" >&2
    echo "0"
  fi
}

detect_gpu() {
  local gpu_info
  gpu_info=$(lspci | grep VGA)
  if echo "$gpu_info" | grep -iq "nvidia"; then
    echo "NVIDIA"
  elif echo "$gpu_info" | grep -iq "amd"; then
    echo "AMD"
  elif echo "$gpu_info" | grep -iq "intel"; then
    echo "Intel"
  elif echo "$gpu_info" | grep -eq "Virtio"; then
    echo "Virtio"
  else
    echo "Unknown"
  fi
}

boldbluetext() {
  local text="$1"
  echo -en "\n${BLUE}${BOLD}$text ${RESET}\n"
}

greentext() {
  local text="$1"
  echo -en "\n${GREEN}$text ${RESET}\n"
}

redtext() {
  local text="$1"
  echo -en "\n${GREEN}$text ${RESET}\n"
}

bluetext() {
  local text="$1"
  echo -en "\n${BLUE}$text ${RESET}\n"
}

root_check() {
  if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}${BOLD}This script requires root priveledges.${RESET}"
    sudo -v
  fi
}

