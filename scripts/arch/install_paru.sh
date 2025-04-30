ensure_in_dir

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf ./paru
