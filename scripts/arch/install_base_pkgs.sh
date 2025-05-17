#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh

pinn brightnessctl

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

# Configure X11 startup
cp -f ./.xinitrc $HOME/.xinitrc

# Installing fonts, mainly relies on nerd fonts' Jetbrains Mono may try others...
pinn ttf-jetbrains-mono ttf-jetbrains-mono-nerd noto-fonts-emoji fontconfig

# Installing and configuring audio stuff
pinn pipewire pipewire-pulse pipewire-jack wireplumber realtime-privileges pavucontrol
# dev/mixer is really old so got to load snd_pcm_oss module manually
sudo touch /etc/modules-load.d/modules.conf && sudo echo "snd-pcm-oss" >>/etc/modules-load.d/modules.conf
