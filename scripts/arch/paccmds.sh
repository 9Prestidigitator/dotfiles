#!/bin/bash

pacupdate() {
  echo -e "\nUpdating system...\n"
  sudo pacman -Syu --noconfirm
}

gitupdate() {
  sudo pacman -S --noconfirm --needed base-devel git
}

pinn() {
  sudo pacman -S --noconfirm --needed "$@"
}
