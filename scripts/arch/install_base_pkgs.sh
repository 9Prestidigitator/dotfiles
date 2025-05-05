#!/bin/bash
set -e
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
elif [[ "$gpud" == "Virtio" ]]; then
  echo -e "\nVirtio graphics detected...\n"
  # Virtio graphics requirements
  pinn xf86-video-qxl xf86-video-vesa xf86-video-qxl xf86-video-vesa mesa
fi

# Installing fonts, mainly relies on nerd fonts' Jetbrains Mono may try others...
pinn ttf-jetbrains-mono ttf-jetbrains-mono-nerd noto-fonts-emoji fontconfig

# Installation of keyd, a really fast keyboard manager
prompt_run "Install keyd" pinn keyd && mkdir -p /etc/keyd && cp -f /.configs/keyd/default.conf /etc/keyd/default.conf

# Installing and configuring security packages
pinn ufw fail2ban openssh
systemctl enable ufw

# Installing and configuring audio stuff
pinn pipewire pipewire-pulse pipewire-jack wireplumber realtime-privileges pavucontrol
# dev/mixer is really old so got to load snd_pcm_oss module manually
touch /etc/modules-load.d/modules.conf && echo "snd-pcm-oss" >>/etc/modules-load.d/modules.conf
# Supposedly adding the user to the realtime group improves audio latency performance
usermod -aG realtime $SUDO_USER

# Battery utils for laptops:
prompt_run "Using a laptop?" $(pinn tlp && systemctl enable --now tlp)
