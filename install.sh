#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/checklist.sh
source ./scripts/bash_functions.sh

main() {
    # Start the option menu
    enable_raw_mode
    trap disable_raw_mode EXIT INT TERM
    while true; do
        render_menu
        if ! handle_input; then
            break
        fi
    done

    # Confirmation of options
    continue_prompt
    # root_check
    # sudo -v
    gitupdate

    # disable_raw_mode
    # printf "\nSelections saved to %s\n" "$CONFIG_FILE"
    # write_config

    [[ ${FLAGS[0]} == "on" ]] && echo "installing bash"
    [[ ${FLAGS[1]} == "on" ]] && echo "installing nvim"
    [[ ${FLAGS[2]} == "on" ]] && echo "installing paru"
}

main "$@"

