#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

# Define colors for scipt ricing
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
BOLD="\e[1m"
ULINE="\e[4m"
RESET="\033[0m"

# Path to use for the checklist configuration
CONFIG_FILE="/tmp/dotschoices.env"

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

detect_distro() {
  local id_like
  local distro
  if [[ -r /etc/os-release ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    if [[ -n "${ID:-}" ]]; then
      distro="$ID"
    elif [[ -n "${ID_LIKE:-}" ]]; then
      distro="$ID_LIKE"
    else
      printf "Unable to detect distribution ID.\n" >&2
      return 1
    fi
  elif command -v lsb_release >/dev/null 2>&1; then
    distro=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
  elif [[ -f /etc/lsb-release ]]; then
    distro=$(grep -i '^DISTRIB_ID=' /etc/lsb-release | cut -d= -f2 | tr '[:upper:]' '[:lower:]')
  else
    printf "Unsupported system: cannot detect distro.\n" >&2
    return 1
  fi
  case "$distro" in
  ubuntu | debian) printf "debian\n" ;;
  arch | manjaro) printf "arch\n" ;;
  fedora | rhel | centos) printf "redhat\n" ;;
  opensuse*) printf "suse\n" ;;
  alpine) printf "alpine\n" ;;
  *) printf "unknown\n" ;;
  esac
}

ensure_in_dir() {
  source $CONFIG_FILE 
  local target_dir="${1:-"$DOTDIR"}"
  target_dir="$(eval printf "%s" "$target_dir")"
  local current_dir
  current_dir="$(realpath "$PWD")"

  local resolved_target
  resolved_target="$(realpath "$target_dir" 2>/dev/null)" || {
    printf "Error: Target directory does not exist: %s\n" "$target_dir" >&2
    return 1
  }

  if [[ "$current_dir" != "$resolved_target" ]]; then
    printf "Changing directory to: %s\n" "$resolved_target"
    cd "$resolved_target" || {
      printf "Error: Could not change to %s\n" "$resolved_target" >&2
      return 1
    }
  fi
}

# Generate user prompt with multiple choice
prompt() {
  local text="$1"
  local color="${2:-1}"
  local user_input
  if [[ $color == 1 ]]; then
    read -p "$(echo -en "\n${GREEN}${BOLD}$text ${RESET}\n")" -rn 1 user_input
  elif [[ $color == 2 ]]; then
    read -p "$(echo -en "\n${BOLD}$text ${RESET}\n")" -rn 1 user_input
  fi
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

# Check if the script user is in root
root_check() {
  if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}${BOLD}This script requires root priveledges.${RESET}"
    sudo -v
  fi
}

# Detects the GPU
detect_gpu() {
  local gpu_info
  gpu_info=$(lspci | grep VGA)
  if echo "$gpu_info" | grep -iq "nvidia"; then
    echo "NVIDIA"
  elif echo "$gpu_info" | grep -iq "amd"; then
    echo "AMD"
  elif echo "$gpu_info" | grep -iq "intel"; then
    echo "Intel"
  elif echo "$gpu_info" | grep -iq "Virtio"; then
    echo "Virtio"
  else
    echo "Unknown"
  fi
}

continue_prompt() {
  read -p $'\nContinue? (y/n):\n ' yn
  case "$yn" in
  [Yy]*) echo "Continuing..." ;;
  [Nn]*)
    echo -e "Aborted."
    exit 1
    ;;
  *)
    echo -e "Invalid input."
    exit 1
    ;;
  esac

}

boldbluetext() {
  local text="$1"
  echo -en "\n${BLUE}${BOLD}$text ${RESET}\n"
}

bluetext() {
  local text="$1"
  echo -en "\n${BLUE}$text ${RESET}\n"
}

greentext() {
  echo -en "\n${GREEN}$1 ${RESET}\n"
}

redtext() {
  echo -en "\n${GREEN}$1 ${RESET}\n"
}

yellowtext() {
  echo -en "\n${YELLOW}$1 ${RESET}\n"
}
