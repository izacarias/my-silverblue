#!/usr/bin/bash

echo "::begin_group:: ===$(basename "$0")==="

set -eoux pipefail

# Setup Systemd

# Disable RPM Fusion repos
for i in /etc/yum.repos.d/rpmfusion-*.repo; do
    if [[ -f "$i" ]]; then
        sed -i 's@enabled=1@enabled=0@g' "$i"
    fi
done

# Disable fedora-coreos-pool if it exists
if [ -f /etc/yum.repos.d/fedora-coreos-pool.repo ]; then
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-coreos-pool.repo
fi


# Remove orphan /usr/lib/modules/ directories left by kernel-tools version bumps
# that don't bring the matching kernel-core. akmods-ostree-post iterates all
# /usr/lib/modules/ entries and fails on those with no matching kernel headers.
for kver_dir in /usr/lib/modules/*/; do
    kver=$(basename "${kver_dir}")
    if ! rpm -q "kernel-core-${kver}" &>/dev/null; then
        echo "Removing orphan /usr/lib/modules/${kver} (no matching kernel-core RPM)"
        rm -rf "${kver_dir}"
    fi
done

echo "Removing temporary files and cache from DNF"
rm -rf /run/dnf
rm -rf /var/lib/dnf /var/cache/dnf /var/cache/ibus /var/cache/ldconfig

echo "Remove files from var-log"
find /var/log -mindepth 1 -delete



echo "::end_group:: ===$(basename "$0")==="
