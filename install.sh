#!/bin/bash
# Rclone variables
rclone_release="rclone-v1.37-linux-amd64"
rclone_zip="${rclone_release}.zip"
rclone_url="https://github.com/ncw/rclone/releases/download/v1.37/${rclone_zip}"
# Plexdrive variables
plexdrive_bin="plexdrive-linux-amd64"
plexdrive_url="https://github.com/dweidenfeld/plexdrive/releases/download/4.0.0/${plexdrive_bin}"
# Rclone
wget "$rclone_url"
unzip "$rclone_zip"
chmod a+x "${rclone_release}/rclone"
cp -rf "${rclone_release}/rclone" "/usr/local/bin/rclone"
rm -rf "$rclone_zip"
rm -rf "$rclone_release"
# Plexdrive
wget "$plexdrive_url"
chmod a+x "$plexdrive_bin"
cp -rf "$plexdrive_bin" "/usr/local/bin/plexdrive"
rm -rf "$plexdrive_bin"