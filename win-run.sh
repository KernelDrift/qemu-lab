#!/usr/bin/env bash
set -e

qemu-system-x86_64 \
    -enable-kvm \
    -machine q35 \
    -cpu host \
    -m 8G \
    -smp 4 \
    -device virtio-vga \
    -drive file=win/windows.qcow2,format=qcow2,if=ide \
    -boot order=c \
    -display gtk,full-screen=on
