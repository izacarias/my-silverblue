#!/usr/bin/bash

echo "::begin_group:: ===$(basename "$0")==="

set -ouex pipefail

# DNF-related operations should be done here whenever possible

FEDORA_PACKAGES=(
     adw-gtk3-theme
     adwaita-fonts-all
     alsa-firmware
     alsa-tools-firmware
     bootc
     containerd
     ddcutil
     distrobox
     evtest
     fastfetch
     firewall-config
     fish
     flatpak-spawn
     gcc
     gcc-c++
     git-credential-libsecret
     gnome-tweaks
     gnupg2-scdaemon
     google-noto-sans-cjk-vf-fonts
     gum
     gvfs-nfs
     ibus-mozc
     ibus-unikey
     igt-gpu-tools
     input-remapper
     just
     libappindicator-gtk3
     libayatana-appindicator-gtk3
     libcamera-gstreamer
     libcamera-tools
     libratbag-ratbagd
     libva-utils
     libxcrypt-compat
     make
     mesa-libGLU
     mozc
     nautilus-gsconnect
     openrgb-udev-rules
     openssh-askpass
     pipewire-libs-extra
     switcheroo-control
     waypipe
     wireguard-tools
     wl-clipboard
     xdg-terminal-exec
     zenity
     zsh
)

# Install Fedora, Tailscale, and multimedia packages together while keeping COPR packages isolated.
echo "Installing ${#FEDORA_PACKAGES[@]} Fedora packages plus Tailscale and multimedia packages..."
# dnf5 config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
# dnf5 config-manager setopt tailscale-stable.enabled=0
dnf5 -y install \
    -x PackageKit* \
    "${FEDORA_PACKAGES[@]}" \
    ffmpeg{,-libs} libavcodec @multimedia gstreamer1-plugins-{bad-free,bad-free-libs,good,base} lame{,-libs} libfdk-aac libjxl ffmpegthumbnailer

## Pins and Overrides
## Use this section to pin packages in order to avoid regressions
# Remember to leave a note with rationale/link to issue for each pin!
#
# Example:
#if [ "$FEDORA_MAJOR_VERSION" -eq "41" ]; then
#    Workaround pkcs11-provider regression, see issue #1943
#    rpm-ostree override replace https://bodhi.fedoraproject.org/updates/FEDORA-2024-dd2e9fb225
#fi

echo "::end_group:: ===$(basename "$0")==="
