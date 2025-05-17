#!/usr/bin/env bash

source ./scripts/bash_functions.sh

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ..
rm -rf ./paru
