source ./scripts/bash_functions.sh

ensure_in_dir

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ..
rm -rf ./paru
