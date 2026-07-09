FROM scratch AS ctx

# Copy folders to the target image
COPY build_files /
COPY system_files /system_files

# Base Image
FROM quay.io/fedora/fedora-bootc:44 

# Modify the base system (add my software and configs)
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

RUN rpm-ostree cleanup -m && \
    ostree container commit
