#!/usr/bin/env bash
set -e -u

echo "=== ORBIT-OS customize_airootfs.sh ==="

systemctl set-default graphical.target
systemctl enable sddm
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable power-profiles-daemon

if [ ! -s /etc/machine-id ]; then
    systemd-machine-id-setup
    echo "machine-id: $(cat /etc/machine-id)"
fi

ln -sf /usr/lib/systemd/system/graphical.target /etc/systemd/system/default.target
ln -sf /usr/lib/systemd/system/sddm.service /etc/systemd/system/display-manager.service
mkdir -p /etc/systemd/system/graphical.target.wants
ln -sf /usr/lib/systemd/system/sddm.service /etc/systemd/system/graphical.target.wants/sddm.service

echo "=== ORBIT-OS customize_airootfs.sh done ==="
