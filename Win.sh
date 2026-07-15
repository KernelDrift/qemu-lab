#!/usr/bin/env bash
OVMF_CODE=$(find /nix/store -path '*OVMF*/FV/OVMF_CODE.fd' 2>/dev/null | head -n 1)


qemu-system-x86_64 \
  -enable-kvm \
  -machine q35 \
  -device virtio-vga \
  -m 8192 \
  -smp 4 \
  -drive if=pflash,format=raw,readonly=on,file="$OVMF_CODE" \
  -drive if=pflash,format=raw,file=VM/EV3/REV3_WS20262027.nvram \
  -drive file=VM/EV3/REV3_WS20262027.qcow2,format=qcow2,if=ide \
  -drive file=VM/virtio-win-0.1.285.iso,media=cdrom
