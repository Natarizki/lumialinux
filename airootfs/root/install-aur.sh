#!/bin/bash
set -e

cleanup() {
  echo "Cleaning up..."
  userdel -r builduser 2>/dev/null || true
  rm -f /etc/sudoers.d/builduser
  echo "Cleanup done!"
}
trap cleanup EXIT

echo "Setting LumiaLinux identity..."
cat > /etc/os-release << OSREL
NAME="LumiaLinux"
PRETTY_NAME="LumiaLinux 1.0"
ID=lumialinux
ID_LIKE=arch
BUILD_ID=rolling
ANSI_COLOR="0;36"
HOME_URL="https://github.com/Natarizki/lumialinux"
SUPPORT_URL="https://github.com/Natarizki/lumialinux/issues"
BUG_REPORT_URL="https://github.com/Natarizki/lumialinux/issues"
OSREL

echo "lumia" > /etc/hostname

useradd -m -s /bin/bash builduser
echo "builduser ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/makepkg" > /etc/sudoers.d/builduser
chmod 440 /etc/sudoers.d/builduser

su - builduser -c "cd /tmp && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm"

su - builduser -c "yay -S --noconfirm --pgpfetch --answerclean A --answerdiff N 66 66-tools calamares calamares-arch-config"

pacman -Qk 66 && echo "66 verified!"
pacman -Qk calamares && echo "Calamares verified!"

mkdir -p /etc/calamares/branding/lumialinux /etc/calamares/modules /etc/xdg/autostart

cat > /etc/calamares/settings.conf << CALACONF
modules-search: [ local, /usr/lib/calamares/modules ]
sequence:
  - show:
    - welcome
    - locale
    - keyboard
    - partition
    - users
    - summary
  - exec:
    - partition
    - mount
    - unpackfs
    - machineid
    - fstab
    - locale
    - keyboard
    - localecfg
    - users
    - networkcfg
    - hwclock
    - services-systemd
    - bootloader
    - unmount
  - show:
    - finished
branding: lumialinux
prompt-install: true
CALACONF

cat > /etc/calamares/branding/lumialinux/branding.desc << BRANDCONF
componentName: lumialinux
welcomeStyleCalamares: true
strings:
  productName: LumiaLinux
  shortProductName: Lumia
  version: 1.0
  versionedName: LumiaLinux 1.0
  bootloaderEntryName: LumiaLinux
  productUrl: https://github.com/Natarizki/lumialinux
  supportUrl: https://github.com/Natarizki/lumialinux/issues
BRANDCONF

cat > /etc/xdg/autostart/calamares.desktop << DESKTOP
[Desktop Entry]
Type=Application
Name=Install LumiaLinux
Exec=calamares
Icon=calamares
NoDisplay=false
DESKTOP

66-enable -t system default 2>/dev/null || true
echo "LumiaLinux setup complete!"
