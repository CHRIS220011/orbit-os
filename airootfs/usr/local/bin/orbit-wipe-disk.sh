#!/bin/bash
set -e

echo "=== ORBIT-OS: wipe disk ==="

# Znajdź pierwszy dysk NVMe lub SATA (nie USB, nie loop)
DISK=$(lsblk -dno NAME,TYPE | awk '$2=="disk" && $1 ~ /^(nvme|sd)/ {print $1}' | grep -v "$(lsblk -no NAME,TRAN | awk '$2=="usb" {print $1}')" | head -1)

if [ -z "$DISK" ]; then
    echo "ERROR: no suitable disk found"
    lsblk
    exit 1
fi

DISK="/dev/$DISK"
echo "Wiping disk: $DISK"

# Wyczyść tablicę partycji
sgdisk --zap-all "$DISK"
wipefs -a "$DISK"
partprobe "$DISK" || true
sleep 2

echo "=== disk wiped ==="
lsblk "$DISK"
