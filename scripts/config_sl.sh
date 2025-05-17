#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
source $CONFIG_FILE
root_check

# I have a couple of dwm scaling presets this is how I'm dealing with it for now...
DISPRESET="${1:-$(prompt $'\tDisplay Presets:\n\t\t1) Around 1080p\n\t\t2) Around 1440p\n' 2)}"
echo "$DISPRESET"
echo -e "\n${BLUE}${BOLD}Configuring suckless programs...${RESET}\n"
if [[ "$DISPRESET" -eq 1 ]]; then
  # Presets for a 1080 screen
  # borderpx, gappx, fontsize, App GUI scale
  config_preset_array1=(2 6 12 1)
elif [[ "$DISPRESET" -eq 2 ]]; then
  # Presets for a 1440 screen
  config_preset_array1=(4 10 24 2)
else
  config_preset_array1=(2 6 12)
fi
# The changing of the variables is quite weird... might replace with something else later
sed -i "s/^\(static const unsigned int borderpx *= *\)[0-9]\+\(.*\)/\1${config_preset_array1[0]}\2/" ./suckless/dwm/config.h
sed -i "s/^\(static const unsigned int gappx *= *\)[0-9]\+\(.*\)/\1${config_preset_array1[1]}\2/" ./suckless/dwm/config.h
sed -i -E "s/(size=)[0-9]+/\1${config_preset_array1[2]}/" ./suckless/dwm/config.h
sed -i -E "s/(GDK_SCALE=)[0-9]+/\1${config_preset_array1[3]}/" ./.bash_profile
sed -i -E "s/(QT_SCALE_FACTOR=)[0-9]+/\1${config_preset_array1[3]}/" ./.bash_profile
