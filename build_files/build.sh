#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
# cp -avf "/ctx/system_files"/. /


## Install packages
dnf5 install -y tmux


## Example for enabling a System Unit File
systemctl enable podman.socket


## Clean files
dnf clean all
# Cache and build logs
rm -rf /var/{cache,log} /var/lib/{dnf,rhsm}

## regenerate initramfs
# echo "=== regenerate initramfs ==="
#RUN set -x; kver=$(cd /usr/lib/modules && echo *); \
#    dracut -vf /usr/lib/modules/$kver/initramfs.img $kver
