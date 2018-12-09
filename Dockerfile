####################
# BASE IMAGE
####################
FROM ubuntu:16.04

MAINTAINER madslundt@live.dk <madslundt@live.dk>


####################
# INSTALLATIONS
####################
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y \
        curl \
        cron \
        fuse \
        unionfs-fuse \
        bc \
        unzip \
        wget \
        ca-certificates && \
    update-ca-certificates && \
    apt-get install -y openssl && \
    sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf

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
    OVERLAY_VERSION=$(curl -sX GET "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]') && \
    curl -o /tmp/s6-overlay.tar.gz -L "https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-amd64.tar.gz" && \
    tar xfz  /tmp/s6-overlay.tar.gz -C /


####################
# ENVIRONMENT VARIABLES
####################
# Encryption
ENV ENCRYPT_MEDIA "1"
ENV READ_ONLY "1"

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

# Plex
ENV PLEX_URL ""
ENV PLEX_TOKEN ""

#cron
ENV CLOUDUPLOADTIME "0 1 * * *"
ENV RMDELETETIME "0 6 * * *"

####################
# SCRIPTS
####################
COPY setup/* /usr/bin/
COPY install.sh /
COPY scripts/* /usr/bin/
COPY root /

RUN chmod a+x /install.sh && \
    sh /install.sh && \
    chmod a+x /usr/bin/* && \
    groupmod -g 1000 users && \
	useradd -u 911 -U -d / -s /bin/false abc && \
	usermod -G users abc && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /tmp/* /var/lib/{apt,dpkg,cache,log}/

####################
# VOLUMES
####################
# Define mountable directories.
#VOLUME /data/db /config /cloud-encrypt /cloud-decrypt /local-decrypt /local-media /chunks /log
VOLUME /data/db /cloud-encrypt /cloud-decrypt /local-decrypt /local-media /chunks /log


RUN chmod -R 777 /data /log && \
    mkdir /config

####################
# WORKING DIRECTORY
####################
WORKDIR /data


####################
# ENTRYPOINT
####################
ENTRYPOINT ["/init"]
CMD cron -f
