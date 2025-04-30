#!/bin/bash

pacupdate() {
  echo -e "\nUpdating system...\n"
  pacman -Syu --noconfirm
}

gitupdate() {
  echo -e "\nThis Script requires GIT to be installed. Checking if GIT is installed...\n"
  pacman -S --noconfirm base-devel git
}

pinn() {
  pacman -S --noconfirm --needed "$1"
}
