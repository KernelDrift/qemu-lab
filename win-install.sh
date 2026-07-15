#!/usr/bin/env bash

set -e

mkdir -p win

if [ ! -f win/windows.qcow2 ]; then
    qemu-img create -f qcow2 win/windows.qcow2 80G
fi

mkdir -p answer
cp win/Autounattend.xml answer/Autounattend.xml

xorriso -as mkisofs \
    -J \
    -R \
    -V AUTOUNATTEND \
    -o win/autounattend.iso \
    win/Autounattend.xml

qemu-system-x86_64 \
    -enable-kvm \
    -machine q35 \
    -cpu host \
    -smp 4 \
    -m 8G \
    -device ich9-ahci,id=sata \
    -drive file=win/windows.qcow2,format=qcow2,if=none,id=windows_disk \
    -device ide-hd,drive=windows_disk,bus=sata.2,bootindex=2 \
    -drive file=win/Win11_25H2_EnglishInternational_x64_v2.iso,format=raw,media=cdrom,if=none,id=windows_iso \
    -device ide-cd,drive=windows_iso,bus=sata.3,bootindex=1 \
    -drive file=win/autounattend.iso,media=cdrom \
    -boot order=d
