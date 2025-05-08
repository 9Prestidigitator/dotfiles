#!/bin/bash

pacupdate() {
  echo -e "\nUpdating system...\n"
  pacman -Syu --noconfirm
}

gitupdate() {
  pacman -S --noconfirm --needed base-devel git
}

pinn() {
  pacman -S --noconfirm --needed "$@"
}
