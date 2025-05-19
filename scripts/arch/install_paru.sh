#!/usr/bin/env bash

source ./scripts/bash_functions.sh
cd $REPO_CLONES

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm

cd ..
rm -rf ./paru
ensure_in_dir
