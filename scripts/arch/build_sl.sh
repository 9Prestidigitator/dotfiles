#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check

# DISPRESET="${1:-$(prompt "Display Presets:\n1) Around 1080p\n2: Around 1440p")}"
DISPRESET="${1:-$(prompt $'\tDisplay Presets:\n\t\t1) Around 1080p\n\t\t2) Around 1440p\n')}"

echo "$DISPRESET"

echo -e "\n${BLUE}${BOLD}Configuring suckless programs...${RESET}\n"
if [[ "$DISPRESET" -eq 1 ]]; then
  # Presets for a 1080 screen
  # borderpx, gappx, *fonts, demenufonts
  config_preset_array1=(2 6 12 12)
elif [[ "$DISPRESET" -eq 2 ]]; then
  # Presets for a 1440 screen
  config_preset_array1=(4 10 24 24)
else
  config_preset_array1=(2 6 12 12)
fi
sed -i "s/^\(static const unsigned int borderpx *= *\)[0-9]\+\(.*\)/\1${config_preset_array1[0]}\2/" ./suckless/dwm/config.h
sed -i "s/^\(static const unsigned int gappx *= *\)[0-9]\+\(.*\)/\1${config_preset_array1[1]}\2/" ./suckless/dwm/config.h
sed -i -E "s/(size=)[0-9]+/\1${config_preset_array1[2]}/" ./suckless/dwm/config.h
# sed -i "s/^\(static const char *fonts[] *= *{ *\"JetBrains Mono:size=\)[0-9]\+\(.*\)/\1${config_preset_array1[2]}\2/" ./suckless/dwm/config.h

echo -e "\nInstalling dependencies...\n"
# X11 packages, slock is a basic lock screen, feh is background manager, picom is effects manager, starship is terminal assistant, keyd is keyboard manager
pacman -S --noconfirm --needed xorg-server xorg-xinit libx11 libxft libxinerama xorgproto xorg-xrandr autorandr xorg-xev brightnessctl slock maim xclip feh picom starship fastfetch keyd
# Installing fonts
pacman -S --noconfirm --needed ttf-jetbrains-mono ttf-jetbrains-mono-nerd noto-fonts-emoji

# Installing and configuring security packages
pacman -S --noconfirm --needed ufw fail2ban openssh
# sudo systemctl enable ufw

# Installing and configuring audio stuff
pacman -S --noconfirm --needed pipewire pipewire-pulse pipewire-jack wireplumber realtime-privileges pavucontrol
# dev/mixer is really old so got to load snd_pcm_oss module manually
touch /etc/modules-load.d/modules.conf && echo "snd-pcm-oss" >>/etc/modules-load.d/modules.conf

usermod -aG realtime $SUDO_USER

echo -e "\nBuilding sl programs.\n${GREEN}${BOLD}Building dwm.${RESET}\n"
cd ./suckless/dwm/ && make clean install
echo -e "\n${GREEN}${BOLD}Building dmenu.${RESET}\n"
cd ../dmenu/ && make clean install
echo -e "\n${GREEN}${BOLD}Building st.${RESET}\n"
cd ../st && make clean install
echo -e "\n${GREEN}${BOLD}Building slstatus.${RESET}\n"
cd ../slstatus/ && make clean install
# Adding config files
cd ../..
cp -f ./.bash_profile /home/$SUDO_USER/.bash_profile
cp -f ./.bashrc /home/$SUDO_USER/.bashrc
cp -f ./.xinitrc /home/$SUDO_USER/.xinitrc
echo -e "\n${YELLOW}Reboot required to take effect.${RESET}\n"

# WIP: Need to find out how to make systemctl calls but these need to be made:
# sudo -u $SUDOUSER systemctl --user enable --now pipewire
# sudo -u $SUDOUSER systemctl --user enable --now pipewire-pulse
# sudo -u $SUDOUSER systemctl --user enable --now wireplumber

# WIP: These commands cause issues apparently
# cp -f /.configs/keyd/default.conf /etc/keyd/default.conf
cp -f ./configs/picom/picom.conf /etc/xdg/picom.conf
feh --bg-fill ./img/wallpaper.jpg
