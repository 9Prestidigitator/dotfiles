#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/bash_functions.sh
distro=$(detect_distro) # Detect the distro that's being used

cursor=0

# Strings for each option and dropdown menu
declare -a OPTIONS=(
  "Terminal Packages"
  "  Neovim"
  "    latexmk"
  "  AUR Helper (paru)"
  "Window Manager"
  "  Hyprland"
  "  dwm"
  "  File Explorer"
  "    Dolphin"
  "    Nautilus"
  "  Browser"
  "    Brave"
  "    Firefox"
  "    Qute"
  "Other Utilities"
  "  Professional Audio"
  "  Virtual Machine"
  "  keyd"
  "  Laptop Setup"
)

# Initial states for installations... might change these
declare -a FLAGS=(
  off
  off off
  off
  off off off
  off off off
  off off off off
  off off off off off
)

# 1 means the option is a container while 2 is a selectable option that's also a container
declare -a EXPANDABLE=(
  1
  2 0
  0
  1 0 0
  1 0 0
  1 0 0 0
  1 0 0 0 0
)

# Indicates what option is required as a dependency to have as an option
declare -a PARENT_ID=(
  0
  0 1
  0
  4 4 4
  4 7 7
  4 10 10 10
  14 14 14 14 14
)

enable_raw_mode() {
  stty -echo -icanon time 0 min 0
  printf "\033[?25l"
}

# Ends the checkbox menu
disable_raw_mode() {
  stty sane
  printf "\033[?25h"
}

render_menu() {
  printf "\033c"
  case "$distro" in
  arch) printf "\n\033[1;34m                       󰣇 arch\033[0m\n" ;;
  debian) printf "\n\033[1;31m                       debian\033[0m\n" ;;
  esac
  printf "╔══════════════════════════════════════════════════╗\n"
  printf "║        \e[34m\e[1mWelcome to my dotfiles syncronizer!\033[0m       ║\n"
  printf "╠══════════════════════════════════════════════════╣\n"
  printf "║   ↑/k ↓/j to move | Space to toggle | Enter OK   ║\n"
  printf "╠══════════════════════════════════════════════════╝\n║\n"

  for i in "${!OPTIONS[@]}"; do
    local visible=1
    local current="$i"
    while ((PARENT_ID[current] != current)); do
      current=${PARENT_ID[current]}
      [[ ${FLAGS[$current]} != "on" ]] && visible=0 && break
    done
    [[ $visible -eq 0 ]] && continue
    if [[ $i -eq $cursor ]]; then
      printf "║ > "
    else
      printf "║   "
    fi
    if [[ ${FLAGS[$i]} == "on" ]]; then
      if [[ ${EXPANDABLE[$i]} -eq 1 ]]; then
        printf " -  %s\n" "${OPTIONS[$i]}"
      else
        printf "[x] %s\n" "${OPTIONS[$i]}"
      fi
    else
      if [[ ${EXPANDABLE[$i]} -eq 1 ]]; then
        printf " +  %s\n" "${OPTIONS[$i]}"
      else
        printf "[ ] %s\n" "${OPTIONS[$i]}"
      fi
    fi
  done
  printf "║\n╚═════════════════════════════════════════════════ \n\n"
}

handle_input() {
  local key
  IFS= read -rsn1 key
  if [[ "$key" == $'\x1b' ]]; then
    read -rsn2 -t 0.01 key2
    case "$key2" in
    "[A") move_cursor -1 ;;
    "[B") move_cursor 1 ;;
    esac
  elif [[ "$key" == "k" ]]; then
    move_cursor -1
  elif [[ "$key" == "j" ]]; then
    move_cursor 1
  elif [[ "$key" == "u" ]]; then
    move_cursor -3
  elif [[ "$key" == "d" ]]; then
    move_cursor 3
  elif [[ "$key" == " " ]]; then
    toggle_flag "$cursor"
  elif [[ "$key" == "" ]]; then
    return 1
  elif [[ "$key" == "q" ]]; then
    printf "\nCancelled.\n" >&2
    exit 1
  fi
  return 0
}

toggle_flag() {
  local i="$1"
  if [[ ${FLAGS[$i]} == "on" ]]; then
    FLAGS[$i]="off"
    if [[ ${EXPANDABLE[$i]:-0} -eq 1 ]]; then
      for j in "${!PARENT_ID[@]}"; do
        [[ ${PARENT_ID[$j]} -eq $i ]] && FLAGS[$j]="off"
      done
    elif [[ ${EXPANDABLE[$i]:-0} -eq 2 ]]; then
      for j in "${!PARENT_ID[@]}"; do
        [[ ${PARENT_ID[$j]} -eq $i ]] && FLAGS[$j]="off"
      done
    fi
  else
    FLAGS[$i]="on"
  fi
}

move_cursor() {
  local delta="$1"
  local max="${#OPTIONS[@]}"
  local i=$cursor
  while :; do
    i=$((i + delta))
    ((i < 0 || i >= max)) && break
    local visible=1
    local current="$i"
    while ((PARENT_ID[current] != current)); do
      current=${PARENT_ID[current]}
      [[ ${FLAGS[$current]} != "on" ]] && visible=0 && break
    done
    [[ $visible -eq 1 ]] && {
      cursor=$i
      break
    }
  done
}

clean_string() {
  local input="$1"
  local clean
  clean="${input//[[:space:]]/}"
  clean="${clean//\\n/}"
  clean="${clean//\\\"/}"
  clean="${clean//\\\'/}"
  clean="${clean//\\/}"
  clean="${clean//\(/}"
  clean="${clean//\)/}"
  printf "%s" "$clean"
}

write_config() {
  : >"$CONFIG_FILE"
  install_path="${1:-"$HOME/dotfiles/"}"

  printf "#!/usr/bin/env bash\n\n" >"$CONFIG_FILE"
  printf "DOTDIR=\"%s\"\n" "${install_path}" >"$CONFIG_FILE"
  for i in "${!OPTIONS[@]}"; do
    local key
    key=$(clean_string "${OPTIONS[$i]}")
    j="${FLAGS[$i]}"
    printf "%s=\"%s\"\n" "$key" "$j" >>"$CONFIG_FILE"
  done
  chmod +x "$CONFIG_FILE"
}
