ensure_in_dir

git clone https://aur.archlinux.org/paru.git
cd paru
sudo -u "$SUDO_USER" makepkg -si --noconfirm
cd ..
rm -rf ./paru
