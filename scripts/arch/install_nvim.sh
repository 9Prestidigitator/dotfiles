#!/usr/bin/env bash

set -euo pipefail

source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
source $CONFIG_FILE

sudo -v

pinn neovim npm python nodejs
[[ ${latexmk} == "on" ]] && pinn zathura zathura-pdf-poppler texlive-core texlive-binextra texlive-science

REPO_URL="https://github.com/9Prestidigitator/nvim.git"
TARGET_DIR="$HOME/.config/nvim"
BACKUP_DIR="$TARGET_DIR.old"

install_nvim_config() {
  if [[ -d "$TARGET_DIR" ]]; then
    if [[ -d "$TARGET_DIR/.git" ]]; then
      local origin_url
      origin_url=$(git -C "$TARGET_DIR" config --get remote.origin.url || true)
      if [[ "$origin_url" == "$REPO_URL" ]]; then
        printf "Updating existing config at %s\n" "$TARGET_DIR"
        git -C "$TARGET_DIR" pull --ff-only
        return
      fi
    fi

    printf "Existing non-repo nvim config found. Backing up to %s\n" "$BACKUP_DIR"
    if [[ -d "$BACKUP_DIR" ]]; then
      rm -rf "$BACKUP_DIR"
    fi
    mv "$TARGET_DIR" "$BACKUP_DIR"
  fi
  printf "Cloning nvim config from %s to %s\n" "$REPO_URL" "$TARGET_DIR"
  git clone "$REPO_URL" "$TARGET_DIR"
}

install_nvim_config
