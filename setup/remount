#!/bin/bash
. "/usr/bin/config"

if [ -z "$(ls -A ${cloud_decrypt_dir})" ] || [ $(ps -ef | grep "unionfs" | grep -v "grep" | wc -l) == "0" ]; then
    echo "[ $(date $(printenv DATE_FORMAT)) ] Mount has dropped. Remount in progress."
    echo "[ $(date $(printenv DATE_FORMAT)) ] Unmounting..."
    fusermount -uz "${cloud_encrypt_dir}"
    fusermount -uz "${cloud_decrypt_dir}"
    fusermount -uz "${local_decrypt_dir}"
    fusermount -uz "${local_media_dir}"
    
    echo "[ $(date $(printenv DATE_FORMAT)) ] Unmounted successfully"
    echo "[ $(date $(printenv DATE_FORMAT)) ] Mounting..."
    mount
    echo "[ $(date $(printenv DATE_FORMAT)) ] Mounted successfully"
fi
