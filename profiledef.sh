#!/usr/bin/env bash
iso_name="lumialinux"
iso_label="LUMIALINUX"
iso_publisher="LumiaLinux"
iso_application="LumiaLinux Arch-based Distro"
iso_version="1.0"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
