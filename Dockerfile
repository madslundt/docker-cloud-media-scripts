# Pull base image.
FROM ubuntu:16.04



# INSTALLATIONS
RUN apt-get update && apt-get install -y \
    curl
    unionfs-fuse \
    bc \
    screen \
    unzip \
    fuse \
    wget

# Install MongoDB.
RUN \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
  echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/mongodb.list && \
  apt-get update && \
  apt-get install -y mongodb-org && \
  rm -rf /var/lib/apt/lists/*



# ENVIRONMENTS
# Rclone
ENV BUFFER_SIZE "500M"
ENV MAX_READ_AHEAD "30G"
ENV CHECKERS "16"

ENV RCLONE_CLOUD_ENDPOINT "gd-crypt:"
ENV RCLONE_LOCAL_ENDPOINT "local-crypt:"

# Plexdrive
ENV CHUNK_SIZE "10M"
ENV CLEAR_CHUNK_MAX_SIZE "1000G"
ENV CLEAR_CHUNK_AGE "24h"

ENV MONGO_DATABASE "plexdrive"

# Time format
ENV DATE_FORMAT "+%F@%T"

# Local files removal
ENV REMOVE_LOCAL_FILES_BASED_ON "space"
ENV REMOVE_LOCAL_FILES_AFTER_DAYS "60"
ENV REMOVE_LOCAL_FILES_WHEN_SPACE_EXCEEDS_GB "2500"
ENV FREEUP_ATLEAST_GB "1000"


COPY /setup/* /usr/local/bin/


COPY /install.sh /
RUN sh /install.sh


# SCRIPTS
COPY /scripts/* /usr/local/bin/

COPY /plexdrive /



# VOLUMES
# Define mountable directories.
VOLUME [
  "/data/db",
  "/config",
  "/cloud-encrypt",
  "/cloud-decrypt",
  "/local-decrypt",
  "/local-media",
  "/chunks",
  "/logs"
]



# WORKING DIRECTORY
# Define working directory.
WORKDIR /data


# COMMANDS
# Define default command.
CMD [
  "mongod",
  "mount.remote"
]