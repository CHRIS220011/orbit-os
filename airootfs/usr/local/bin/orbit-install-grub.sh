#!/bin/bash
set -e

echo "=== ORBIT-OS: grub-install ==="

if [ -d /sys/firmware/efi ]; then
    BOOT_MODE="UEFI"
else
    BOOT_MODE="BIOS"
fi
echo "Boot mode: $BOOT_MODE"

ROOT_DEV=$(awk '$2 == "/" {print $1}' /etc/fstab | sed 's/^UUID=//')
if [[ ! "$ROOT_DEV" =~ ^/dev/ ]]; then
    ROOT_DEV=$(blkid -U "$ROOT_DEV")
fi
echo "Root device: $ROOT_DEV"

DISK_NAME=$(lsblk -no PKNAME "$ROOT_DEV")
DISK="/dev/$DISK_NAME"
echo "Parent disk: $DISK"

mkdir -p /boot/grub
cat > /boot/grub/device.map <<DEVICEMAP
(hd0)   $DISK
DEVICEMAP

if [ "$BOOT_MODE" = "UEFI" ]; then
    EFI_UUID=$(awk '$2 == "/boot/efi" {print $1}' /etc/fstab | sed 's/^UUID=//')
    EFI_DEV=$(blkid -U "$EFI_UUID")
    echo "EFI device: $EFI_DEV"

    mkdir -p /boot/efi
    mountpoint -q /boot/efi || mount "$EFI_DEV" /boot/efi

    # Zamontuj efivarfs (MUSI być przed grub-install/efibootmgr)
    mkdir -p /sys/firmware/efi/efivars
    mountpoint -q /sys/firmware/efi/efivars || mount -t efivarfs efivarfs /sys/firmware/efi/efivars
    echo "--- efivars mounted ---"

    echo "--- current efibootmgr ---"
    efibootmgr 2>&1 | head -20

    # grub-install do ORBIT-OS
    echo "--- grub-install (UEFI) ---"
    if grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ORBIT-OS --recheck --no-floppy 2>&1; then
        echo "grub-install OK"
    else
        grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ORBIT-OS --recheck --no-nvram --no-floppy 2>&1
    fi

    # === FALLBACK: --removable (dla firmware wymagających /EFI/BOOT/BOOTX64.EFI) ===
    echo "--- grub-install --removable (fallback dla NVRAM) ---"
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ORBIT-OS --recheck --no-nvram --removable --no-floppy 2>&1 || true

    echo "--- EFI files ---"
    ls -la /boot/efi/EFI/ORBIT-OS/ 2>&1
    ls -la /boot/efi/EFI/BOOT/ 2>&1

    # efibootmgr --create
    echo "--- efibootmgr --create ---"
    EFI_PART_NUM=$(echo "$EFI_DEV" | grep -oE '[0-9]+$')
    efibootmgr --create --disk "$DISK" --part "$EFI_PART_NUM" \
        --label "ORBIT-OS" \
        --loader '\EFI\ORBIT-OS\grubx64.efi' 2>&1 || echo "efibootmgr create failed"

    # Ustaw ORBIT-OS jako pierwszy
    ORBIT_ENTRY=$(efibootmgr 2>/dev/null | grep -i "ORBIT-OS" | grep -oE 'Boot[0-9A-F]+' | head -1 | sed 's/Boot//')
    if [ -n "$ORBIT_ENTRY" ]; then
        echo "Setting Boot$ORBIT_ENTRY as first..."
        efibootmgr --bootorder "$ORBIT_ENTRY" 2>&1 || true
    fi

    echo "--- final efibootmgr ---"
    efibootmgr 2>&1
else
    grub-install --target=i386-pc --recheck --no-floppy "$DISK" 2>&1
fi

grub-mkconfig -o /boot/grub/grub.cfg 2>&1

echo "=== ORBIT-OS: grub-install done ==="
