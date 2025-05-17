#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/9Prestidigitator/nvim.git"
TARGET_DIR="$HOME/.config/nvim"
BACKUP_DIR="$TARGET_DIR.old"

install_latest_neovim() {
  local tmp_dir
  tmp_dir=$(mktemp -d)
  local appimage_url
  local appimage_path="$tmp_dir/nvim.appimage"
  printf "Fetching latest Neovim release metadata...\n"
  local json

  if ! json=$(curl -sSL https://api.github.com/repos/neovim/neovim/releases/latest); then
    printf "Error: Failed to fetch release info.\n" >&2
    return 1
  fi
  if ! appimage_url=$(printf "%s" "$json" |
    grep "browser_download_url" |
    grep "nvim-linux-x86_64.appimage\"" |
    cut -d '"' -f 4); then
    printf "Error: Could not find .appimage URL.\n" >&2
    return 1
  fi
  if [[ -z "$appimage_url" ]]; then
    printf "Error: Neovim AppImage not found.\n" >&2
    return 1
  fi

  printf "Downloading Neovim AppImage...\n"
  curl -L --fail -o "$appimage_path" "$appimage_url"
  printf "Making AppImage executable...\n"
  chmod u+x "$appimage_path"
  printf "Installing Neovim to /usr/local/bin/nvim...\n"

  sudo mv "$appimage_path" /usr/local/bin/nvim
  sudo chmod 755 /usr/local/bin/nvim

  printf "Cleaning up temporary files...\n"
  rm -rf "$tmp_dir"
  printf "✅ Neovim installed successfully.\n"
  nvim --version | head -n 1
}

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

install_latest_neovim
install_nvim_config
