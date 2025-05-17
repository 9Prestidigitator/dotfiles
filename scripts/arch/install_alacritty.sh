#!/usr/bin/env bash

source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check

pinn alacritty
mkdir -p ~/.config/nvim && cp -fr ./configs/alacritty $HOME/.config/
