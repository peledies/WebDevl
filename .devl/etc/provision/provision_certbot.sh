#!/bin/bash

URL=${1:-"example.com"}
WEBROOT=${2:-"/var/www/html"}
ADMIN_EMAIL=${3:-"admin@example.com"}

vagrant_build_log=/home/ubuntu/vm_build.log

##########################
# Ensure Root privileges #
##########################
if [ "$(whoami)" != "root" ]; then
  echo "!- You will need to run this with root, or sudo. -!"
  exit 1
fi

echo -e "\n--- Installing LetsEncrypt Certbot ---\n"
sudo apt-get install software-properties-common -y >> $vagrant_build_log 2>&1
sudo add-apt-repository ppa:certbot/certbot -y >> $vagrant_build_log 2>&1
sudo apt-get update
sudo apt-get install python-certbot-nginx -y >> $vagrant_build_log 2>&1

echo -e "\n--- Generating SSL Cert for $URL ---\n"
sudo certbot \
  --nginx -n \
  --agree-tos \
  --redirect \
  --keep-until-expiring \
  -m $ADMIN_EMAIL \
  -d $URL \
  --renew-hook "/home/ubuntu/certbot_renewal_email.sh $EMAIL $URL" \
  --webroot-path $WEBROOT >> $vagrant_build_log 2>&1

if grep -Fxq "30 2 * * 1 /usr/bin/certbot renew --logs-dir /var/log/letsencrypt/" /var/spool/cron/crontabs/root
then
  echo -e "\n--- Skipping Certbot Renewal crontab addition, line exists ---\n"
else
  echo -e "\n--- Adding Certbot Renewal line to root crontab ---\n"
  #write out current crontab
  crontab -l > ohmycron
  #echo new cron into cron file
  echo "30 2 * * 1 /usr/bin/certbot renew --logs-dir /var/log/letsencrypt/"  >> ohmycron
  #install new cron file
  crontab ohmycron
  rm ohmycron
fi


echo -e "\n--- Creating Renewal Email Script ---\n"

cat <<EOF > /home/ubuntu/certbot_renewal_email.sh
#!/bin/bash

EMAIL=\${1:-"deac@sfp.net"}
DOMAIN=\${2:-"Domain Not Specified"}

mail -s "Certbot Certificate Renewal" -t \$EMAIL <<< \$DOMAIN
EOF

chmod +x /home/ubuntu/certbot_renewal_email.sh