#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

OVMF_CODE=$(find /nix/store -path '*OVMF*/FV/OVMF_CODE.fd' | head -n1)

qemu-system-x86_64 \
    -enable-kvm \
    -machine q35 \
    -cpu host \
    -m 8G \
    -smp 4 \
    -device virtio-vga \
    -drive if=pflash,format=raw,readonly=on,file="$OVMF_CODE" \
    -drive if=pflash,format=raw,file=win/windows.nvram \
    -drive file=win/windows.qcow2,format=qcow2,if=ide \
    -boot order=c
