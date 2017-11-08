#!/bin/bash

. "/usr/bin/variables"

printf "\n\n\n==============================================================\n"
if [ -f "/config/config.json" ] || [ -f "/config/token.json" ]; then
  echo "Plexdrive has already been set up. Remove /config/config.json and /config/token.json and run setup again."
else
  echo "Setup Plexdrive"
  printf "==============================================================\n\n\n"

  plexdrive $mongo $plexdrive_options "${cloud_encrypt_dir}"
fi
