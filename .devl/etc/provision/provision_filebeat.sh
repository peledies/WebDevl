#!/bin/bash

ELKMASTER=${1:-"localhost"}
PROJECTROOT=${2:-"/home/ubuntu"}

vagrant_build_log=/home/ubuntu/vm_build.log

echo -e "\n=============================\n=== Provisioning Filebeat ===\n=============================\n"

echo -e "\n--- Installing Filebeat ---\n"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - >> $vagrant_build_log 2>&1
sudo apt-get install apt-transport-https -y >> $vagrant_build_log 2>&1
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list >> $vagrant_build_log 2>&1
sudo apt-get update && sudo apt-get install filebeat -y >> $vagrant_build_log 2>&1


echo -e "\n--- Configuring Filebeat ---\n"

printf "\n$ELKMASTER elk-master" | sudo tee -a /etc/hosts >> $vagrant_build_log 2>&1

sudo sed -i.${date +"%s"}.bak "s/  - \/var\/log\/\*.log/  - \/var\/log\/\*.log \n    - \/var\/log\/secure \n    - \/var\/log\/messages\n    - \/var\/log\/http/access_log\n    - \/var\/log\/http/error_log \n\ndocument-type: syslog/g" /etc/filebeat/filebeat.yml >> $vagrant_build_log 2>&1

sudo sed -i "s/^output.elasticsearch:/#output.elasticsearch:/g" /etc/filebeat/filebeat.yml >> $vagrant_build_log 2>&1

sudo sed -i "s/^  hosts: [\"localhost:9200\"]/#  hosts: [\"localhost:9200\"]/g" /etc/filebeat/filebeat.yml >> $vagrant_build_log 2>&1

sudo sed -i "s/^#output.logstash:/output.logstash:\n  hosts: \[\"elk-master:5443\"\]\n  bulk_max_size: 2048\n  ssl.certificate_authorities: \[\"\/etc\/filebeat\/logstash.crt\"\]\n  template.name: \"filebeat\"\n  template.path: \"filebeat.template.json\"\n  template.overwrite: false/g" /etc/filebeat/filebeat.yml >> $vagrant_build_log 2>&1

cp $PROJECTROOT/logstash.crt /etc/filebeat/ >> $vagrant_build_log 2>&1

echo -e "\n--- Enabling Filebeat ---\n"

sudo update-rc.d filebeat defaults 95 10 >> $vagrant_build_log 2>&1