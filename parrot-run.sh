OVMF_DIR=$(dirname "$(find / -name "OVMF_CODE.fd" 2>/dev/null | head -n1)")
OVMF_CODE="$OVMF_DIR/OVMF_CODE.fd"
OVMF_VARS="$OVMF_DIR/OVMF_VARS.fd"


qemu-system-x86_64 \
    -enable-kvm \
    -machine q35 \
    -cpu host \
    -m 8G \
    -smp 4 \
    -device virtio-vga \
    -drive if=pflash,format=raw,readonly=on,file="$OVMF_CODE" \
    -drive if=pflash,format=raw,file=parrot/parrot.nvram \
    -drive file=parrot/parrot.qcow2,format=qcow2,if=virtio \
    -boot order=c \
    -display gtk,full-screen=on
