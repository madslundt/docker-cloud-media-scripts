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
    unionfs-fuse \
    bc \
    screen \
    unzip \
    fuse \
    wget

# MongoDB 3.4
    RUN \
   apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
   echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
   apt-get update && \
   apt-get install -y mongodb-org


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
COPY setup/* /usr/local/bin/

COPY install.sh /
RUN sh /install.sh

COPY scripts/* /usr/local/bin/


####################
# VOLUMES
####################
# Define mountable directories.
VOLUME /data/db /config /cloud-encrypt /cloud-decrypt /local-decrypt /local-media /chunks /log


####################
# WORKING DIRECTORY
####################
WORKDIR /data


####################
# COMMANDS
####################
CMD init