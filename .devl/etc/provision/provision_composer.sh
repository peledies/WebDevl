#!/bin/bash

vagrant_build_log=/home/ubuntu/vm_build.log

echo -e "\n=================================\n=== Provisioning PHP Composer ===\n=================================\n"

## Install composer
if ! type "composer" > /dev/null; then
echo -e "\n--- Installing PHP Composer ---\n"
  curl -sS https://getcomposer.org/installer | php >> $vagrant_build_log 2>&1
  sudo mv composer.phar /usr/local/bin/composer >> $vagrant_build_log 2>&1
  chmod +x /usr/local/bin/composer >> $vagrant_build_log 2>&1
  chown -R ubuntu:ubuntu /home/ubuntu/.composer >> $vagrant_build_log 2>&1
else
  echo -e "\n--- PHP Composer Already Installed ---\n"
fi