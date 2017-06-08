#!/bin/bash

vagrant_build_log=/home/ubuntu/vm_build.log

echo -e "\n===========================\n=== Provisioning NodeJS ===\n===========================\n"

## Install Nodejs
if ! type "node" > /dev/null; then
  echo -e "\n--- Installing Nodejs ---\n"
    curl -sL https://deb.nodesource.com/setup_6.x -o /home/ubuntu/nodesource_setup.sh >> $vagrant_build_log 2>&1
    chmod +x /home/ubuntu/nodesource_setup.sh >> $vagrant_build_log 2>&1
    bash /home/ubuntu/nodesource_setup.sh >> $vagrant_build_log 2>&1
    apt-get install nodejs -y >> $vagrant_build_log 2>&1
else
  echo -e "\n--- Nodejs Already Installed ---\n"
fi