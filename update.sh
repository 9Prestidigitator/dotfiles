#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check
pacupdate
gitupdate

ensure_in_dir
git pull https://github.com/9Prestidigitator/dotfiles.git
./scripts/build_sl.sh
./scripts/config_bash.sh
