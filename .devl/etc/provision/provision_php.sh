#!/bin/bash

vagrant_build_log=/home/ubuntu/vm_build.log

echo -e "\n========================\n=== Provisioning PHP ===\n========================\n"

echo -e "\n--- Installing Common PHP Server Dependencies ---\n"
  apt install php php-curl php7.0-mysql php-mcrypt php-gd php-mbstring php7.0-zip php-simplexml -y >> $vagrant_build_log 2>&1
