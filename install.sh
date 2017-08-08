#!/bin/sh
# Rclone variables
rclone_url="https://github.com/ncw/rclone/releases/download/v1.36/rclone-v1.36-linux-amd64.zip"
rclone_zip="rclone-v1.36-linux-amd64.zip"
rclone_dir="rclone-v1.36-linux-amd64"
# Plexdrive variables
plexdrive_url="https://github.com/dweidenfeld/plexdrive/releases/download/4.0.0/plexdrive-linux-amd64"
plexdrive_bin="plexdrive-linux-amd64"
# Rclone
wget "$rclone_url"
unzip "$rclone_zip"
chmod a+x "${rclone_dir}/rclone"
cp -rf "${rclone_dir}/rclone" "/usr/local/bin/rclone"
rm -rf "$rclone_zip"
rm -rf "$rclone_dir"
# Plexdrive
wget "$plexdrive_url"
chmod a+x "$plexdrive_bin"
cp -rf "$plexdrive_bin" "/usr/local/bin/plexdrive"
rm -rf "$plexdrive_bin"