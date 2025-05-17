source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check

pinn qemu-full qemu-img libvirt virt-install virt-manager virt-viewer edk2-ovmf dnsmasq swtpm guestfs-tools libosinfo tuned
sudo systemctl enable libvirtd.service
sudo usermod -aG libvirt $(whoami)
