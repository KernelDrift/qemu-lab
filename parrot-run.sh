OVMF_DIR="$(nix-build '<nixpkgs>' -A OVMF.fd --no-out-link)/FV"
OVMF_CODE="$OVMF_DIR/OVMF_CODE.fd"


qemu-system-x86_64 \
    -enable-kvm \
    -machine q35 \
    -cpu host \
    -m 16G \
    -smp 4 \
    -device virtio-vga \
    -drive if=pflash,format=raw,readonly=on,file="$OVMF_CODE" \
    -drive if=pflash,format=raw,file=parrot/parrot.nvram \
    -drive file=parrot/parrot.qcow2,format=qcow2,if=virtio \
    -boot order=c \
    -display gtk,full-screen=on
