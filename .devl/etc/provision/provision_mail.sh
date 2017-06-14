#!/bin/bash

MAILNAME=${1:-"example.com"}

vagrant_build_log=/home/ubuntu/vm_build.log

##########################
# Ensure Root privileges #
##########################
if [ "$(whoami)" != "root" ]; then
  echo "!- You will need to run this with root, or sudo. -!"
  exit 1
fi

debconf-set-selections <<< "postfix postfix/mailname string $MAILNAME"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt-get install -y mailutils >> $vagrant_build_log 2>&1