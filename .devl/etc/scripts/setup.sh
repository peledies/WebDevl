#!/bin/bash
pushd $(dirname $0) > /dev/null; SCRIPTPATH=$(pwd); popd > /dev/null
INITDIR=`pwd`
TEMPLATEDIR=SCRIPTPATH/../templates

project=$1
source $SCRIPTPATH/../assets/info_box.sh
source $SCRIPTPATH/../assets/pretty_tasks.sh

clear

info_box "New Project Setup"

if [ -z "$1" ];then
  read -p "What is the project name: ${gold}" project
  echo "${default}"
else
  project=$1
fi

provision() {
  echo $1
  parse_flame $1
}

parse_flame() {
  flame=$(cat $SCRIPTPATH/../vagrant/provision_$1.flame)
  grep -o '\bEVIL_\w*' $SCRIPTPATH/../vagrant/provision_$1.flame | while read line ; do
    read -p "${cyan} Enter Value for ${line}: ${gold}" NICE </dev/tty
    flame=$(sed "s/${line}/${NICE}/" <<< $flame)
  done
echo $flame
  vagrant=$(cat $SCRIPTPATH/../vagrant/vagrant.evil)
echo $vagrant
  vagrant=$(sed "s/EVIL_PROVISION_APACHE/${flame}/" <<< $vagrant)
  echo $vagrant
}

_menu () {
  echo "${green}  Provisioning Options"
  echo " ===================${normal}"
  echo "${magenta} 1 ${default}- Apache 2"
  echo "${magenta} 2 ${default}- PHP"
  echo "${magenta} 3 ${default}- Composer"
  echo "${magenta} 4 ${default}- Git Remote"
  echo "${magenta} 5 ${default}- MySql"
  echo "${magenta} 6 ${default}- Nginx Reverse Proxy"
  echo "${magenta} 7 ${default}- Node JS"
  echo "${magenta} 8 ${default}- PM2 for Node"
  echo "${magenta} 9 ${default}- Laravel"
  echo "${magenta} x ${default}- Done"

  echo -e "\n"
  while true; do
    read -p "${cyan} Select an option from the list above: ${gold}" answer
    case $answer in
      1 ) clear; provision "apache"; _menu; break;;
      2 ) clear; provision "php"; _menu; break;;
      3 ) clear; provision "composer"; _menu; break;;
      4 ) clear; provision "git_remote"; _menu; break;;
      5 ) clear; provision "mysql"; _menu; break;;
      6 ) clear; provision "nginx_rev_proxy"; _menu; break;;
      7 ) clear; provision "node"; _menu; break;;
      8 ) clear; provision "pm2"; _menu; break;;
      9 ) clear; provision "laravel"; _menu; break;;
      x ) clear; exit; break;;

      * ) echo "Please select a valid option.";;
    esac
  done
}

_menu