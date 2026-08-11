#!/usr/bin/env bash

set -e

if [ ! -f windows.qcow2 ]; then
    qemu-img create -f qcow2 windows.qcow2 80G
fi

xorriso -as mkisofs \
    -J \
    -R \
    -V AUTOUNATTEND \
    -o autounattend.iso \
    Autounattend.xml

qemu-system-x86_64 \
    -enable-kvm \
    -machine q35 \
    -cpu host \
    -smp 4 \
    -m 8G \
    -device ich9-ahci,id=sata \
    -drive file=windows.qcow2,format=qcow2,if=none,id=windows_disk \
    -device ide-hd,drive=windows_disk,bus=sata.2,bootindex=2 \
    -drive file=Win11_25H2_EnglishInternational_x64_v2.iso,format=raw,media=cdrom,if=none,id=windows_iso \
    -device ide-cd,drive=windows_iso,bus=sata.3,bootindex=1 \
    -drive file=autounattend.iso,media=cdrom \
    -boot order=d
