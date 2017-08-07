#!/bin/sh

# Rclone variables
_rclone_url="https://github.com/ncw/rclone/releases/download/v1.36/rclone-v1.36-linux-amd64.zip"
_rclone_zip="rclone-v1.36-linux-amd64.zip"
_rclone_dir="rclone-v1.36-linux-amd64"

# Plexdrive variables
_plexdrive_url="https://github.com/dweidenfeld/plexdrive/releases/download/4.0.0/plexdrive-linux-amd64"
_plexdrive_bin="plexdrive-linux-amd64"


# Rclone
wget "${_rclone_url}"
unzip "${_rclone_zip}"
chmod a+x "${_rclone_dir}/rclone"
cp -rf "${_rclone_dir}/rclone" "/usr/local/bin/rclone"
rm -rf "${_rclone_zip}"
rm -rf "${_rclone_dir}"

# Plexdrive
wget "${_plexdrive_url}"
chmod a+x "${_plexdrive_url}"
cp -rf "${_plexdrive_bin}" "/usr/local/bin/plexdrive"
rm -rf "${_plexdrive_bin}"




if [ ! -d "${local_decrypt_dir}" ]; then
    mkdir -p "${local_decrypt_dir}"
fi

if [ ! -d "${plexdrive_temp_dir}" ]; then
    mkdir -p "${plexdrive_temp_dir}"
fi