#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check

# I have a couple of dwm scaling presets this is how I'm dealing with it for now...
DISPRESET="${1:-$(prompt $'\t${RESET}${BOLD}Display Presets:\n\t\t1) Around 1080p\n\t\t2) Around 1440p\n')}"
echo "$DISPRESET"
echo -e "\n${BLUE}${BOLD}Configuring suckless programs...${RESET}\n"
if [[ "$DISPRESET" -eq 1 ]]; then
  # Presets for a 1080 screen
  # borderpx, gappx, fontsize, App GUI scale
  config_preset_array1=(2 6 12 1)
elif [[ "$DISPRESET" -eq 2 ]]; then
  # Presets for a 1440 screen
  config_preset_array1=(4 10 24 2)
else
  config_preset_array1=(2 6 12)
fi
# The changing of the variables is quite weird... might replace with something else later
sed -i "s/^\(static const unsigned int borderpx *= *\)[0-9]\+\(.*\)/\1${config_preset_array1[0]}\2/" ./suckless/dwm/config.h
sed -i "s/^\(static const unsigned int gappx *= *\)[0-9]\+\(.*\)/\1${config_preset_array1[1]}\2/" ./suckless/dwm/config.h
sed -i -E "s/(size=)[0-9]+/\1${config_preset_array1[2]}/" ./suckless/dwm/config.h
sed -i -E "s/(GDK_SCALE=)[0-9]+/\1${config_preset_array1[3]}/" ./.bash_profile
sed -i -E "s/(QT_SCALE_FACTOR=)[0-9]+/\1${config_preset_array1[3]}/" ./.bash_profile

# run build_sl script
echo -e "\nInstalling dependencies...\n"
pinn base-devel xorg-server xorg-xinit xorg-xset libx11 libxft libxinerama fontconfig
./scripts/build_sl.sh

# Extra X11 packages: slock is a basic lock screen, feh is background manager, picom is effects manager, starship is terminal assistant, keyd is keyboard manager
pinn xorgproto xorg-xrandr autorandr xorg-xev xf86-input-evdev xf86-video-qxl mesa-utils brightnessctl slock maim xclip feh picom 
cp -f ./configs/picom/picom.conf /etc/xdg/picom.conf

# Configure bash stuff
pinn starship fastfetch 
./scripts/config_bash.sh

gpud=$(detect_gpu)
if [[ $gpud -eq "Intel" ]]; then
  # Intel graphics requirements
  bluetext "Intel graphics detected..."
  pacman -S --noconfirm --needed mesa libva-intel-driver libvdpau-va-gl vulkan-intel
elif [[ $gpud -eq "AMD" ]]; then
  # AMD graphics requirements
  redtext "AMD graphics detected..."
  pacman -S --noconfirn --needed mesa xf86-video-amdgpu vulkan-radeon libva-mesa-driver libvdpau-va-gl
elif [[ $gpud -eq "NVIDIA" ]]; then
  greentext "Nvidia graphics detected...more work required"
  # Nvidia graphics requirements
  pacman -S --noconfirm --needed nvidia nvidia-utils nvidia-settings
elif [[ $gpud -eq "Virtio" ]]; then
  # Virtio graphics requirements
  pacman -S --noconfirm --needed xf86-video-qxl xf86-video-vesa xf86-video-qxl xf86-video-vesa
fi

# Installing fonts, mainly relies on nerd fonts' Jetbrains Mono may try others...
pinn ttf-jetbrains-mono ttf-jetbrains-mono-nerd noto-fonts-emoji

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
prompt_run "Using a laptop?" pinn tlp && systemctl enable --now tlp

# Installation of keyd
prompt_run "Install keyd" pinn keyd && mkdir -p /etc/keyd && cp -f /.configs/keyd/default.conf /etc/keyd/default.conf

