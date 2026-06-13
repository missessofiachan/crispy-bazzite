#!/bin/bash

set -ouex pipefail

### 1. Install download tools
dnf5 install -y tar wget

### 2. Fetch bleeding-edge upstream linux-firmware
echo "Downloading latest upstream linux-firmware..."
wget -q https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-main.tar.gz

mkdir -p /tmp/linux-firmware-extract
tar -xzf linux-firmware-main.tar.gz -C /tmp/linux-firmware-extract --strip-components=1

### 3. Copy targeted files for Z890 UD WIFI6E hardware variations
echo "Syncing Intel AX211 & Realtek RTL8852CE blobs..."

# Target Intel (for Rev 1.0)
cp -r /tmp/linux-firmware-extract/iwlwifi-*.bin /usr/lib/firmware/
cp -r /tmp/linux-firmware-extract/intel/ibt-* /usr/lib/firmware/intel/ 2>/dev/null || cp -r /tmp/linux-firmware-extract/intel /usr/lib/firmware/

# Target Realtek (for Rev 1.1, 1.2, 1.3)
cp -r /tmp/linux-firmware-extract/rtw89 /usr/lib/firmware/
cp -r /tmp/linux-firmware-extract/rtl_bt /usr/lib/firmware/

### 4. Cleanup build artifacts
rm -rf linux-firmware-main.tar.gz /tmp/linux-firmware-extract
dnf5 remove -y tar wget

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf5 install -y ripgrep 


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
