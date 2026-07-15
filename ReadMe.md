## Windows Setup

1. Download the Windows 11 ISO and the latest VirtIO driver ISO:
   - Windows 11: https://www.microsoft.com/en-us/software-download/windows11
   - VirtIO Drivers: https://fedora-virt.repo.nfrance.com/virtio-win/direct-downloads/stable-virtio/

2. Place both ISO files in the `win/` directory.

3. Run `win-install.sh` from the `win/` directory.

4. After Windows installation, install the VirtIO Guest Tools from the mounted VirtIO ISO.
   - If you skip this step, use `win-run.sh` first to boot Windows with the standard graphics adapter, install the VirtIO Guest Tools, and then reboot.

5. For all future boots, simply use `win-run.sh`.

---

## Parrot OS

1. Download the latest Parrot OS QCOW:
   - https://www.parrotsec.org/download/](https://deb.parrot.sh/parrot/iso/7.3/Parrot-security-7.3_amd64.qcow2.zip)

2. Place the ISO in the `parrot/` directory.

3. Run `parrot-install.sh`.

4. Complete the installation normally.

5. After the installation has finished, remove the ISO (or use `parrot-run.sh`) and boot directly from `parrot.qcow2`.

No additional VirtIO drivers are required, as they are already included in the Linux kernel.

