# Pull base image.
FROM jlesage/baseimage-gui:debian-10

# Define software download URLs.
ARG DOWNLOAD_URL=https://github.com/tonikelope/megabasterd/releases/download/v7.74/MegaBasterdLINUX_7.74_portable.zip

#Download Megabasterd
RUN \
    apt -qq update && \
    apt install -qq -y curl \
    	unzip \
        && \
    mkdir -p /defaults && \
    cd /defaults && \
    curl -# -L -o /defaults/MegaBasterd.zip ${DOWNLOAD_URL} && \
    unzip -q MegaBasterd.zip && \
    mv MegaBasterdLINUX/ MegaBasterd && \
    # Cleanup.
    apt remove -qq -y unzip && \
    rm -rf MegaBasterd.zip /tmp/* /tmp/.[!.]*

# Copy Megabasterd app
#COPY MegaBasterd /defaults/MegaBasterd

# Copy the start script.
COPY rootfs/ /

# Set the name of the application.
ENV APP_NAME="MegaBasterd"
