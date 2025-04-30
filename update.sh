#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
pacupdate
gitupdate

ensure_in_dir

echo -e "\n${BLUE}${BOLD}--- Updating dotfiles ---${RESET}\n"

prompt_run "Want to update repository?" git pull https://github.com/9Prestidigitator/dotfiles.git

root_check
./scripts/build_sl.sh
./scripts/config_bash.sh
