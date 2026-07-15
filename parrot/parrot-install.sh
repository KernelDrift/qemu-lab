#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

if [ -f Parrot-security-7.3_amd64.qcow2.zip ] && [ ! -f parrot.qcow2 ]; then
    unzip Parrot-security-7.3_amd64.qcow2.zip
    rm Parrot-security-7.3_amd64.qcow2.zip

    mv Parrot-security-7.3_amd64.qcow2 parrot.qcow2
fi


OVMF_DIR=$(dirname "$(find / -name "OVMF_CODE.fd" 2>/dev/null | head -n1)")
OVMF_CODE="$OVMF_DIR/OVMF_CODE.fd"
OVMF_VARS="$OVMF_DIR/OVMF_VARS.fd"

if [ ! -f parrot.nvram ]; then
    cp "$OVMF_VARS" parrot.nvram
    chmod u+w parrot.nvram
fi
