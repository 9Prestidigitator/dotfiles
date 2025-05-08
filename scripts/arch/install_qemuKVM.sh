source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check

pacman -S --needed qemu-full qemu-img libvirt virt-install virt-manager virt-viewer edk2-ovmf dnsmasq swtpm guestfs-tools libosinfo tuned || true
systemctl enable libvirtd.service
usermod -aG libvirt $(whoami)
