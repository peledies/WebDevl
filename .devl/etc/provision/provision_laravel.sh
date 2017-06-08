#!/bin/bash

ROOT=${3:-/var/www/html/}
DIR=${4:-""} # OPTIONAL - Must not include pre slash, and must include trailing slash

vagrant_build_log=/home/ubuntu/vm_build.log

echo -e "\n=======================================\n=== Provisioning Laravel Components ===\n=======================================\n"

## Update permissions of the laravel storage directory
echo -e "\n--- Updating permissions of the laravel storage directory ---\n"
  chown -R www-data:ubuntu ${ROOT}${DIR}storage >> $vagrant_build_log 2>&1

if grep -Fxq "* * * * * /usr/bin/php ${ROOT}${DIR}artisan schedule:run >> /dev/null 2>&1" /var/spool/cron/crontabs/root
then
  echo -e "\n--- Skipping Laravel schedule runner crontab addition, line exists ---\n"
else
  echo -e "\n--- Adding Laravel schedule runner line to root crontab ---\n"
  #write out current crontab
  crontab -l > ohmycron
  #echo new cron into cron file
  echo "* * * * * /usr/bin/php ${ROOT}${DIR}artisan schedule:run >> /dev/null 2>&1"  >> ohmycron
  #install new cron file
  crontab ohmycron
  rm ohmycron
fi

echo -e "\n--- Updating permissions so root user can execute artisan ---\n"
  chmod 774 ${ROOT}${DIR}artisan >> $vagrant_build_log 2>&1
