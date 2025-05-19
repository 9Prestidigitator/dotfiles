#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh

sudo -v

pinn alacritty
mkdir -p ~/.config/nvim && cp -fr ./configs/alacritty $HOME/.config/
