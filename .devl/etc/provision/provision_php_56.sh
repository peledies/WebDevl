#!/bin/bash

build_log=/home/ubuntu/build.log

echo -e "\n===========================\n=== Provisioning PHP 5.6 ===\n===========================\n"

echo -e "\n--- Adding ondrej Apt Repository ---\n"
  add-apt-repository ppa:ondrej/php -y >> $build_log 2>&1

echo -e "\n--- Updating packages list ---\n"
  apt-get -qq update

echo -e "\n--- Removing PHP 7.0 ---\n"
  apt-get remove php7.0 --purge -y >> $build_log 2>&1

echo -e "\n--- Installing Common PHP Server Dependencies ---\n"
  apt install libapache2-mod-php5.6 php5.6 php5.6-curl php5.6-mysql php5.6-mcrypt php5.6-gd php5.6-mbstring php5.6-zip php5.6-simplexml -y