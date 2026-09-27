#!/bin/bash
set -e

echo "=== locateimg: szukam airootfs.sfs i vmlinuz-linux ==="
mkdir -p /run/archiso/bootmnt/orbit/x86_64
mkdir -p /run/archiso/bootmnt/orbit/boot/x86_64

TARGET_SFS="/run/archiso/bootmnt/orbit/x86_64/airootfs.sfs"
TARGET_KERN="/run/archiso/bootmnt/orbit/boot/x86_64/vmlinuz-linux"

# === Znajdź airootfs.sfs ===
SFS=$(find /run/archiso -name "airootfs.sfs" 2>/dev/null | head -1)
if [ -n "$SFS" ] && [ "$SFS" != "$TARGET_SFS" ]; then
    rm -f "$TARGET_SFS"
    ln -s "$SFS" "$TARGET_SFS"
    echo "SFS: $SFS -> $TARGET_SFS"
elif [ -n "$SFS" ]; then
    echo "SFS: already in place ($SFS)"
else
    echo "ERROR: airootfs.sfs not found!"
    exit 1
fi

# === Znajdź vmlinuz-linux ===
KERN=""
# 1. Standardowe ścieżki
for candidate in \
    /run/archiso/bootmnt/orbit/boot/x86_64/vmlinuz-linux \
    /run/archiso/bootmnt/boot/x86_64/vmlinuz-linux \
    /run/archiso/bootmnt/orbit/boot/vmlinuz-linux \
    /run/archiso/bootmnt/boot/vmlinuz-linux; do
    if [ -f "$candidate" ]; then
        KERN="$candidate"
        echo "KERN found at: $candidate"
        break
    fi
done

# 2. W /run/archiso, /mnt, /media, /tmp
if [ -z "$KERN" ]; then
    echo "Not in standard paths, searching /run/archiso /mnt /media /tmp..."
    KERN=$(find /run/archiso /mnt /media /tmp -name "vmlinuz-linux" 2>/dev/null | head -1)
fi

# 3. Fallback – zamontuj ponownie USB (jeśli copytoram odmontował)
if [ -z "$KERN" ]; then
    echo "Remounting ISO device..."
    ISO_DEV=$(blkid -t TYPE=iso9660 -o device 2>/dev/null | head -1)
    if [ -z "$ISO_DEV" ]; then
        ISO_DEV=$(blkid | grep -i "ORBIT_OS" | cut -d: -f1 | head -1)
    fi
    if [ -n "$ISO_DEV" ]; then
        echo "ISO device: $ISO_DEV"
        mkdir -p /mnt/orbit-iso
        mount -o ro "$ISO_DEV" /mnt/orbit-iso 2>/dev/null || true
        KERN=$(find /mnt/orbit-iso -name "vmlinuz-linux" 2>/dev/null | head -1)
    fi
fi

# 4. Ostatecznie – cały system
if [ -z "$KERN" ]; then
    echo "Searching whole system..."
    KERN=$(find / -name "vmlinuz-linux" 2>/dev/null | grep -v "/proc/" | head -1)
fi

if [ -n "$KERN" ]; then
    if [ "$KERN" != "$TARGET_KERN" ]; then
        rm -f "$TARGET_KERN"
        cp "$KERN" "$TARGET_KERN"
        echo "KERN: $KERN -> $TARGET_KERN (copied)"
    else
        echo "KERN: already in place ($KERN)"
    fi
else
    echo "ERROR: vmlinuz-linux not found anywhere!"
    echo "=== Files in /run/archiso ==="
    find /run/archiso -type f 2>/dev/null | head -30
    echo "=== Mount points ==="
    mount | head -20
    echo "=== block devices ==="
    blkid
    exit 1
fi

echo "=== final ==="
ls -la /run/archiso/bootmnt/orbit/x86_64/
ls -la /run/archiso/bootmnt/orbit/boot/x86_64/
