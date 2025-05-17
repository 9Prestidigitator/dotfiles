#!/usr/bin/env bash

set -euo pipefail

source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check

pinn neovim npm python nodejs
prompt_run "Install necessary latex packages?" pacman -S --needed --noconfirm zathura zathura-pdf-poppler texlive-core texlive-binextra texlive-science

REPO_URL="https://github.com/9Prestidigitator/nvim.git"

