#for nix
#OVMF_DIR="$(nix-build '<nixpkgs>' -A OVMF.fd --no-out-link)/FV"
#OVMF_CODE="$OVMF_DIR/OVMF_CODE.fd"
#normal linux
OVMF_CODE="/usr/share/OVMF/OVMF_CODE_4M.fd"

# UEFI NVRAM einmalig erstellen
if [ ! -f "kali/kali.nvram" ]; then
    cp "$OVMF_CODE" "kali/kali.nvram"
fi


qemu-system-x86_64 \
    -enable-kvm \
    -machine q35 \
    -cpu host \
    -m 16G \
    -smp 4 \
    -vga std \
    -device qemu-xhci \
    -device usb-tablet \
    -drive file=kali/kali.qcow2,format=qcow2,if=virtio \
    -boot order=c \
    -display gtk,full-screen=on,zoom-to-fit=on,gl=off
    -virtfs local,path="kali/share",mount_tag=hostshare,security_model=none,readonly=on
