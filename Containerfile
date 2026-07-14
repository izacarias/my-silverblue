ARG BASE_IMAGE_NAME="silverblue"
ARG FEDORA_MAJOR_VERSION="44"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/silverblue"
ARG BASE_IMAGE_REF="${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}"
ARG BREW_IMAGE="ghcr.io/ublue-os/brew:latest"

FROM ${BREW_IMAGE} AS brew

FROM scratch AS ctx

# Copy folders to the target image
COPY /system_files /system_files
COPY /build_files /build_files
COPY --from=brew /system_files /system_files/shared

# Base Image
FROM ${BASE_IMAGE_REF} AS base-common

# Modify the base system (add my software and configs)
RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,source=/build_files,target=/ctx/build_files \
#    --mount=type=bind,from=ctx,source=/image-versions.yml,target=/ctx/image-versions.yml \
#    --mount=type=secret,id=GITHUB_TOKEN \
    --mount=type=tmpfs,dst=/boot \
    bash -euo pipefail -c ' \
        dnf5 config-manager setopt keepcache=1 && \
        dnf5 config-manager setopt install_weak_deps=0 && \
        /ctx/build_files/base/02-copy-files.sh && \
        /ctx/build_files/base/03-packages.sh && \
        /ctx/build_files/base/05-override-install.sh && \
        /ctx/build_files/base/99-cleanup.sh \
    '

# Makes `/opt` writeable by default
# Needs to be here to make the main image build strict (no /opt there)
# This is for downstream images/stuff like k0s
RUN rm -rf /opt && ln -s /var/opt /opt

CMD ["/sbin/init"]

RUN bootc container lint --fatal-warnings
