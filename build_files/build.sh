#!/bin/bash

set -ouex pipefail

# 1. Ensure target firmware directory exists
mkdir -p /usr/lib/firmware/intel

# 2. Download the exact missing Bluetooth files directly
echo "Fetching missing Intel Bluetooth configuration files..."
curl -fLo /usr/lib/firmware/intel/ibt-1040-0000.sfi \
  https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/intel/ibt-1040-0000.sfi

curl -fLo /usr/lib/firmware/intel/ibt-1040-0000.ddc \
  https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/intel/ibt-1040-0000.ddc

# 3. Fetch the absolute latest Wi-Fi microcode for your AX211 card
echo "Updating Intel AX211 Wi-Fi microcode..."
curl -fLo /usr/lib/firmware/iwlwifi-so-a0-gf-a0-89.ucode \
  https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/iwlwifi-so-a0-gf-a0-89.ucode

#### Example for enabling a System Unit File
systemctl enable podman.socket