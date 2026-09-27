#!/bin/bash
set -e

echo "=== ORBIT-OS grubfix starting ==="
echo "--- /etc/fstab ---"
cat /etc/fstab
echo "--- /proc/cmdline ---"
cat /proc/cmdline
echo "--- current /boot/grub/grub.cfg (linux lines) ---"
grep -E "linux(efi)?\s" /boot/grub/grub.cfg || echo "NO linux LINES FOUND"

# Znajdź UUID partycji root z /etc/fstab
ROOT_UUID=$(awk '$2 == "/" {print $1}' /etc/fstab | sed 's/^UUID=//')
if [ -z "$ROOT_UUID" ]; then
    echo "ERROR: cannot find root UUID in fstab"
    exit 1
fi
echo "Root UUID: $ROOT_UUID"

# Nadpisz /etc/default/grub – to jest źródło prawdy dla grub-mkconfig
cat > /etc/default/grub <<GRUBEOF
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="ORBIT-OS"
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX="root=UUID=$ROOT_UUID"
GRUB_DISABLE_OS_PROBER=false
GRUBEOF

echo "--- new /etc/default/grub ---"
cat /etc/default/grub

# Regeneruj grub.cfg
echo "--- running grub-mkconfig ---"
grub-mkconfig -o /boot/grub/grub.cfg 2>&1 | tail -20

echo "--- final grub.cfg (linux lines) ---"
grep -E "linux(efi)?\s" /boot/grub/grub.cfg || echo "STILL NO linux LINES"
echo "=== ORBIT-OS grubfix done ==="
