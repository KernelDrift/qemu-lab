Für Windows braucht es einen OMVF Code dieser befindet sich hier:

find /nix/store -name OVMF_CODE.fd 2>/dev/null
/nix/store/zp51g43pr03sisri6xs1nyba6j2ad5kc-OVMF-202602-fd/FV/OVMF_CODE.fd


Starten einer Windows-VM:

qemu-system-x86_64 \
  -enable-kvm \
  -machine q35 \
  -m 8192 \
  -smp 4 \
  -drive if=pflash,format=raw,readonly=on,file=/nix/store/zp51g43pr03sisri6xs1nyba6j2ad5kc-OVMF-202602-fd/FV/OVMF_CODE.fd \
  -drive file=REV3_WS20262027.qcow2,format=qcow2,if=ide


QEMU Windows VM auf NixOS
Struktur
QEMU/
├── EV3/
│   ├── REV3_WS20262027.qcow2
│   └── REV3_WS20262027.nvram
├── EV3.sh
└── ReadMe.md
VM starten
./EV3.sh

Beispiel EV3.sh:

#!/usr/bin/env nix-shell
#! nix-shell -i bash -p qemu

qemu-system-x86_64 \
  -enable-kvm \
  -machine q35 \
  -m 8192 \
  -smp 4 \
  -drive if=pflash,format=raw,readonly=on,file=/nix/store/zp51g43pr03sisri6xs1nyba6j2ad5kc-OVMF-202602-fd/FV/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=EV3/REV3_WS20262027.nvram \
  -drive file=EV3/REV3_WS20262027.qcow2,format=qcow2,if=ide
Aus QEMU raus-tabben

Bei GTK-Fenster:

Ctrl + Alt + G

Damit wird Maus und Tastatur wieder vom Host freigegeben.

VM sauber beenden

In Windows normal herunterfahren.

Alternativ im QEMU-Fenster:

Ctrl + Alt + 2

Dann im QEMU-Monitor:

system_powerdown

Zurück zur VM-Anzeige:

Ctrl + Alt + 1
Zustand sichern
Variante 1: Snapshot im qcow2-Image

Snapshot erstellen:

qemu-img snapshot -c clean-install EV3/REV3_WS20262027.qcow2

Snapshots anzeigen:

qemu-img snapshot -l EV3/REV3_WS20262027.qcow2

Snapshot wiederherstellen:

qemu-img snapshot -a clean-install EV3/REV3_WS20262027.qcow2

Snapshot löschen:

qemu-img snapshot -d clean-install EV3/REV3_WS20262027.qcow2
Variante 2: Datei kopieren

Einfach, robust, aber braucht mehr Speicherplatz:

cp EV3/REV3_WS20262027.qcow2 EV3/REV3_WS20262027.backup.qcow2
cp EV3/REV3_WS20262027.nvram EV3/REV3_WS20262027.backup.nvram

Wiederherstellen:

cp EV3/REV3_WS20262027.backup.qcow2 EV3/REV3_WS20262027.qcow2
cp EV3/REV3_WS20262027.backup.nvram EV3/REV3_WS20262027.nvram

VirtualBox-Image zu qcow2 konvertieren
VDI zu qcow2
qemu-img convert -f vdi -O qcow2 REV3_WS20262027.vdi REV3_WS20262027.qcow2
VMDK zu qcow2
qemu-img convert -f vmdk -O qcow2 disk.vmdk disk.qcow2
OVA entpacken und konvertieren
tar -xvf vm.ova

Danach liegt meistens eine .vmdk-Datei vor:

qemu-img convert -f vmdk -O qcow2 disk.vmdk disk.qcow2


VirtualBox-NVRAM verwenden

Wenn die VirtualBox-VM EFI verwendet, gibt es oft eine .nvram-Datei.

Diese kann in QEMU als beschreibbarer pflash-Speicher verwendet werden:

-drive if=pflash,format=raw,file=EV3/REV3_WS20262027.nvram

Die UEFI-Firmware selbst kommt von OVMF:

-drive if=pflash,format=raw,readonly=on,file=/nix/store/.../OVMF_CODE.fd

ISO einbinden

Windows- oder Linux-ISO booten

qemu-system-x86_64 \
  -enable-kvm \
  -machine q35 \
  -m 8192 \
  -smp 4 \
  -cdrom installer.iso \
  -boot d \
  -drive file=disk.qcow2,format=qcow2,if=ide

ISO zusätzlich zur bestehenden VM einbinden

qemu-system-x86_64 \
  -enable-kvm \
  -machine q35 \
  -m 8192 \
  -smp 4 \
  -drive if=pflash,format=raw,readonly=on,file=/nix/store/zp51g43pr03sisri6xs1nyba6j2ad5kc-OVMF-202602-fd/FV/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=EV3/REV3_WS20262027.nvram \
  -drive file=EV3/REV3_WS20262027.qcow2,format=qcow2,if=ide \
  -cdrom pfad/zur/datei.iso

Neue leere qcow2-Disk erstellen

qemu-img create -f qcow2 disk.qcow2 80G

Wichtige Hinweise

Diese VM stammt aus VirtualBox und verwendet:

EFI
SATA/AHCI
8192 MB RAM
4 CPUs

Deshalb wird sie mit QEMU über OVMF und IDE/AHCI-kompatiblem Disk-Modus gestartet.

virtio wäre schneller, kann aber bei einer übernommenen Windows-Installation zu Bootproblemen führen, wenn die passenden Treiber noch nicht installiert sind.
