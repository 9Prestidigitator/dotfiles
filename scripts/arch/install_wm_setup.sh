#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
source $CONFIG_FILE
ensure_in_dir

sudo -v

# Essential packages no matter what display manager you use
pinn brightnessctl bluez bluez-utils blueman archlinux-xdg-menu dunst adw-gtk-theme
sudo systemctl enable --now bluetooth

# Installing fonts, mainly relies on nerd fonts' Jetbrains Mono may try others...
pinn ttf-jetbrains-mono ttf-jetbrains-mono-nerd noto-fonts-emoji fontconfig

gpud=$(detect_gpu)
if [[ "$gpud" == "Intel" ]]; then
  # Intel graphics requirements
  bluetext "Intel graphics detected..."
  pinn mesa mesa-utils libva-intel-driver libvdpau-va-gl vulkan-intel
elif [[ "$gpud" == "AMD" ]]; then
  # AMD graphics requirements
  redtext "AMD graphics detected..."
  pinn mesa xf86-video-amdgpu vulkan-radeon libva-mesa-driver libvdpau-va-gl
elif [[ "$gpud" == "NVIDIA" ]]; then
  greentext "Nvidia graphics detected...more work required"
  # Nvidia graphics requirements
  pinn nvidia nvidia-utils nvidia-settings
  # Also install nvidia-zen for zen kernel for example
elif [[ "$gpud" == "Virtio" ]]; then
  echo -e "\nVirtio graphics detected...\n"
  # Virtio graphics requirements
  pinn xf86-video-qxl xf86-video-vesa xf86-video-qxl xf86-video-vesa mesa
fi

# Installing audio stuff
pinn pipewire pipewire-pulse pipewire-jack wireplumber realtime-privileges pavucontrol
