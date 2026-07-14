#!/usr/bin/bash

echo "::begin_group:: ===$(basename "$0")==="

set -ouex pipefail

# DNF-related operations should be done here whenever possible

# Copy Files to Image
# rsync -rvK /ctx/system_files/dx/ /

install -Dm0755 /ctx/build_files/shared/utils/ghcurl /usr/bin/ghcurl

echo "::end_group:: ===$(basename "$0")==="
