####################
# BASE IMAGE
####################
FROM ubuntu:16.04

MAINTAINER madslundt@live.dk <madslundt@live.dk>


####################
# INSTALLATIONS
####################
RUN apt-get update && apt-get install -y \
    curl \
    fuse \
    unionfs-fuse \
    bc \
    screen \
    unzip \
    wget

RUN apt-get update && apt-get install -y ca-certificates && update-ca-certificates && apt-get install -y openssl
RUN sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf
RUN chmod 777 /var/run/screen

# MongoDB 3.4
RUN \
   apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
   echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
   apt-get update && \
   apt-get install -y mongodb-org

# S6 overlay
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_KEEP_ENV=1

RUN \
    OVERLAY_VERSION=$(curl -sX GET "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]') && \
    curl -o \
    /tmp/s6-overlay.tar.gz -L \
    "https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-amd64.tar.gz" && \
    tar xfz \
    /tmp/s6-overlay.tar.gz -C /


####################
# ENVIRONMENT VARIABLES
####################
# Encryption
ENV ENCRYPT_MEDIA "1"

# Rclone
ENV BUFFER_SIZE "500M"
ENV MAX_READ_AHEAD "30G"
ENV CHECKERS "16"
ENV RCLONE_CLOUD_ENDPOINT "gd-crypt:"
ENV RCLONE_LOCAL_ENDPOINT "local-crypt:"

# Plexdrive
ENV CHUNK_SIZE "10M"
ENV CLEAR_CHUNK_MAX_SIZE ""
ENV CLEAR_CHUNK_AGE "24h"
ENV MONGO_DATABASE "plexdrive"

# Time format
ENV DATE_FORMAT "+%F@%T"

# Local files removal
ENV REMOVE_LOCAL_FILES_BASED_ON "space"
ENV REMOVE_LOCAL_FILES_WHEN_SPACE_EXCEEDS_GB "100"
ENV FREEUP_ATLEAST_GB "80"
ENV REMOVE_LOCAL_FILES_AFTER_DAYS "30"



####################
# SCRIPTS
####################
COPY setup/* /usr/bin/

COPY install.sh /

COPY scripts/* /usr/bin/

RUN chmod a+x /install.sh
RUN sh /install.sh
RUN chmod a+x /usr/bin/*

COPY root /

# Create abc user
RUN groupmod -g 1000 users && \
	useradd -u 911 -U -d / -s /bin/false abc && \
	usermod -G users abc

####################
# VOLUMES
####################
# Define mountable directories.
VOLUME /data/db /config /cloud-encrypt /cloud-decrypt /local-decrypt /local-media /chunks /log

RUN chmod -R 777 /data
RUN chmod -R 777 /log

####################
# WORKING DIRECTORY
####################
WORKDIR /data


####################
# ENTRYPOINT
####################
ENTRYPOINT ["/init"]