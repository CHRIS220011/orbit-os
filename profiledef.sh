#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="orbit-os-1.0"
iso_label="ORBIT_OS"
iso_publisher="ORBIT-OS (CHRIS) <https://orbit-os.example.com>"
iso_application="ORBIT-OS 1.0 Live/Install Media"
iso_version="1.0"
install_dir="orbit"
buildmodes=('iso')
bootmodes=('bios.syslinux'
           'uefi.systemd-boot')
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '19' '-b' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
  ["/etc/skel/Desktop/orbit-install.desktop"]="0:0:755"
  ["/usr/local/bin/orbit-locateimg.sh"]="0:0:755"
  ["/usr/local/bin/orbit-fix-grub.sh"]="0:0:755"
  ["/usr/local/bin/orbit-install-grub.sh"]="0:0:755"
  ["/root/customize_airootfs.sh"]="0:0:755"
  ["/etc/machine-id"]="0:0:444"
  ["/usr/local/bin/orbit-wipe-disk.sh"]="0:0:755"
)
