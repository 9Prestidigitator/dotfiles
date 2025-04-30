#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
pacupdate
gitupdate

ensure_in_dir
git pull https://github.com/9Prestidigitator/dotfiles.git

root_check
./scripts/build_sl.sh
./scripts/config_bash.sh
