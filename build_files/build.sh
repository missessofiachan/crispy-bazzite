#!/bin/bash

set -ouex pipefail

### 1. Install download prerequisites
# (Required temporarily to download and extract the upstream firmware snapshot)
dnf5 install -y tar wget

### 2. Fetch bleeding-edge upstream linux-firmware
echo "Downloading latest upstream linux-firmware snapshot..."
wget -q https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-main.tar.gz

mkdir -p /tmp/linux-firmware-extract
tar -xzf linux-firmware-main.tar.gz -C /tmp/linux-firmware-extract --strip-components=1

### 3. Sync targeted firmware into the image paths
echo "Syncing updated Intel Wi-Fi & Bluetooth firmware blobs..."

# Overwrite existing Intel Wi-Fi ucode files (Addresses the -110 initialization timeout)
cp -f /tmp/linux-firmware-extract/iwlwifi-*.bin /usr/lib/firmware/

# Supply the missing Intel Bluetooth firmware directory (Fixes the missing -2 file error)
mkdir -p /usr/lib/firmware/intel
cp -rf /tmp/linux-firmware-extract/intel/* /usr/lib/firmware/intel/

### 4. Cleanup build artifacts
echo "Cleaning up build workspace..."
rm -rf linux-firmware-main.tar.gz /tmp/linux-firmware-extract
dnf5 remove -y tar wget

### 5. Install user packages (Optional)
# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images.
# Example:
# dnf5 install -y ripgrep 

#### Example for enabling a System Unit File
systemctl enable podman.socket