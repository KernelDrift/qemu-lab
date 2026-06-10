#!/usr/bin/env bash

qemu-system-x86_64 \
  -enable-kvm \
  -machine q35 \
  -device virtio-vga \
  -m 8192 \
  -smp 4 \
  -drive if=pflash,format=raw,readonly=on,file=/nix/store/zp51g43pr03sisri6xs1nyba6j2ad5kc-OVMF-202602-fd/FV/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=VM/EV3/REV3_WS20262027.nvram \
  -drive file=VM/EV3/REV3_WS20262027.qcow2,format=qcow2,if=ide \
  -drive file=VM/virtio-win-0.1.285.iso,media=cdrom
