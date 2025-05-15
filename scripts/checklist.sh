#!/usr/bin/env bash

set -euo pipefail
shopt -s extglob

readonly CONFIG_FILE="/tmp/dots_sync.env"

# Strings for each option and dropdown menu
declare -a OPTIONS=(
    "Terminal Packages"
        "  Neovim"
        "  AUR Helper (paru)"
    "Window Manager"
        "  Hyprland"
        "  dwm"
    "GUI Packages"
    "  Dolphin"
    "  Nautilus"
    "Professional Audio"
    "Virtual Machine"
)

# Initial states for installations... might change these
declare -a FLAGS=(
    off off off
    off off off off off off
    off 
    off
)

# 1 means the option is a container while 2 is a selectable option that's also a container
declare -a EXPANDABLE=(
    2 0 0
    1 0 0 
    1 0 0
    0
    0
)

# Indicates what option is required as a dependency to have as an option
declare -a PARENT_ID=(
    0 0 0
    3 3 3 
    3 6 6
    3 
    3
)

cursor=0

enable_raw_mode() {
    stty -echo -icanon time 0 min 0
}

# Ends the checkbox menu
disable_raw_mode() {
    stty sane
    printf "\n╚══════════════════════════════════════════════════╝\n\n"
}

render_menu() {
    printf "\033c"
    printf "╔══════════════════════════════════════════════════╗\n"
    printf "║        \e[34m\e[1mWelcome to my dotfiles syncronizer!\033[0m       ║\n"
    printf "╠══════════════════════════════════════════════════╣\n"
    printf "║   ↑/k ↓/j to move | Space to toggle | Enter OK   ║\n"
    printf "╚══════════════════════════════════════════════════╝\n\n"

    for i in "${!OPTIONS[@]}"; do
        local visible=1
        local current="$i"
        while (( PARENT_ID[current] != current )); do
            current=${PARENT_ID[current]}
            [[ ${FLAGS[$current]} != "on" ]] && visible=0 && break
        done
        [[ $visible -eq 0 ]] && continue
        if [[ $i -eq $cursor ]]; then
            printf " > "
        else
            printf "   "
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
        (( i < 0 || i >= max )) && break
        local visible=1
        local current="$i"
        while (( PARENT_ID[current] != current )); do
            current=${PARENT_ID[current]}
            [[ ${FLAGS[$current]} != "on" ]] && visible=0 && break
        done
        [[ $visible -eq 1 ]] && { cursor=$i; break; }
    done
}

write_config() {
    : > "$CONFIG_FILE"
    printf "#!/usr/bin/env bash\n\n" > "$CONFIG_FILE"
    if [[ ${FLAGS[0]} == "on" ]]; then
        printf "${OPTIONS[0]}" >> "$CONFIG_FILE"
        [[ ${FLAGS[0]} == "on" ]] && printf "'git' " >> "$CONFIG_FILE"
        [[ ${FLAGS[2]} == "on" ]] && printf "'vim' " >> "$CONFIG_FILE"
        [[ ${FLAGS[3]} == "on" ]] && printf "'build-essential' " >> "$CONFIG_FILE"
        printf ")\n" >> "$CONFIG_FILE"
    fi
    if [[ ${FLAGS[4]} == "on" ]]; then
        printf "MEDIA_TOOLS=(" >> "$CONFIG_FILE"
        [[ ${FLAGS[5]} == "on" ]] && printf "'vlc' " >> "$CONFIG_FILE"
        [[ ${FLAGS[6]} == "on" ]] && printf "'gimp' " >> "$CONFIG_FILE"
        [[ ${FLAGS[7]} == "on" ]] && printf "'audacity' " >> "$CONFIG_FILE"
        printf ")\n" >> "$CONFIG_FILE"
    fi
    if [[ ${FLAGS[8]} == "on" ]]; then
        printf "NET_UTILS=(" >> "$CONFIG_FILE"
        [[ ${FLAGS[9]} == "on" ]] && printf "'curl' " >> "$CONFIG_FILE"
        [[ ${FLAGS[10]} == "on" ]] && printf "'wget' " >> "$CONFIG_FILE"
        [[ ${FLAGS[11]} == "on" ]] && printf "'nmap' " >> "$CONFIG_FILE"
        printf ")\n" >> "$CONFIG_FILE"
    fi
    chmod +x "$CONFIG_FILE"
}

# main() {
#     enable_raw_mode
#     trap disable_raw_mode EXIT INT TERM
#
#     while true; do
#         render_menu
#         if ! handle_input; then
#             break
#         fi
#     done
#
#     disable_raw_mode
#     printf "\nSelections saved to %s\n" "$CONFIG_FILE"
#     write_config
# }

# main "$@"

