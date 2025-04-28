#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check
pacupdate

browser="${1:-$(prompt "Choose your browser: \nBrave(1)\nFirefox(2)\nQutebrowser(3)")}"
fileexplorer="${2:-$(prompt "Choose your file explorer: \nNautilus(1)\nDolphin(2)")}"

# browser=prompt "Choose your browser: \nBrave(1)\nFirefox(2)\nQutebrowser(3)"
if [[ $browser eq 1 ]]; then
  pacman -S --needed firefox || true
elif [[ $browser eq 2 ]]; then
  pacman -S --needed brave || true
elif [[ $browser eq 2 ]]; then
  pacman -S --needed qutebrowser || true
fi
if [[ $fileexplorer eq 1 ]]; then
  pacman -S --needed nautilus || true
elif [[ $fileexplorer eq 2 ]]; then
  pacman -S --needed dolphin || true
fi
