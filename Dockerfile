#
# megabasterd Dockerfile
#
#https://github.com/gauravsuman007/megabasterd-docker.git
#
# NOTES:
#   - We are using JRE version 8 because recent versions are much bigger.
#   - JRE for ARM 32-bits on Alpine is very hard to get:
#     - The version in Alpine repo is very, very slow.
#     - The glibc version doesn't work well on Alpine with a compatibility
#       layer (gcompat or libc6-compat).  The `__xstat` symbol is missing and
#       implementing a wrapper is not straight-forward because the `struct stat`
#       is not constant across architectures (32/64 bits) and glibc/musl.
#

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=

# Define software download URLs.
ARG VERSION=7.76
ARG DOWNLOAD_URL=https://github.com/tonikelope/megabasterd/releases/download/v${VERSION}/MegaBasterdLINUX_${VERSION}_portable.zip

# Download MegaBasterd
FROM --platform=$BUILDPLATFORM alpine:3.16 AS alp
ARG DOWNLOAD_URL
RUN \
    apk --no-cache add curl unzip && \
    mkdir -p /defaults && \
    cd /defaults && \
#    curl -# -L -o /defaults/MegaBasterd.jar ${DOWNLOAD_URL}
    curl -# -L -o /defaults/MegaBasterd.zip ${DOWNLOAD_URL} && \
    unzip -q MegaBasterd.zip && \
    mv MegaBasterdLINUX/ MegaBasterd && \
    rm -rf MegaBasterd/jre && \
    # Cleanup.
    apk del unzip curl && \
    rm -rf MegaBasterd.zip /tmp/* /tmp/.[!.]*

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.16-v4.4.2

ARG DOCKER_IMAGE_VERSION

# Define working directory.
WORKDIR /tmp

# Install dependencies.
RUN \
    add-pkg \
        java-common \
        openjdk8-jre \
        # Needed by the init script.
        jq \
        # We need a font.
        ttf-dejavu \
        # For ffmpeg and ffprobe tools.
        #ffmpeg \
        # For rtmpdump tool.
        rtmpdump \
        # Need for the sponge tool.
        moreutils

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://cdn-icons-png.flaticon.com/256/873/873133.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /
COPY --from=alp /defaults/MegaBasterd /defaults/MegaBasterd

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "MegaBasterd" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    true

# Define mountable directories.
VOLUME ["/output"]

# Metadata.
LABEL \
      org.label-schema.name="MegaBasterd" \
      org.label-schema.description="Docker container for MegaBasterd" \
      org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
      org.label-schema.vcs-url="https://github.com/gauravsuman007/megabasterd-docker.git" \
      org.label-schema.schema-version="1.0"
