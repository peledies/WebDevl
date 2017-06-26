#!/bin/bash
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
default=$(tput sgr0)

vagrant_database=${1:-"vagrant"}
vagrant_mount=${2:-"/var/www/html/"}

FILES=()
for filename in ./*.sql; do
  FILES+=($filename)
done

echo -e "\n${cyan}Select File to Import Into Vagrant Database${default}\n"
i=0
for each in "${FILES[@]}"
do
  ((i++))
  echo "${magenta}$i${default} $each"
done

echo -e "\n"
read -p "${cyan}Import: ${magenta}" IMPORT </dev/tty
echo -e "${default}"

com="mysql -uroot ${vagrant_database} < ${vagrant_mount}${FILES[$(($IMPORT-1))]}"
echo $com
vagrant ssh -- -t "$com"
