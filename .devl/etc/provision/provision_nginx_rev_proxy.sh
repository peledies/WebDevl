#!/bin/bash

SOURCE=${1:-/opt/local_marketing_insights}
NAME=${2:-"local_marketing_insights"}
PORT=${3:-3000}

vagrant_build_log=/home/ubuntu/vm_build.log
echo -e "\n=================================\n=== Provisioning Nginx Server ===\n=================================\n"

echo -e "\n--- Installing nginx ---\n"
  apt-get install nginx -y >> $vagrant_build_log 2>&1

echo -e "\n--- Enabling nginx ---\n"
  sudo systemctl enable nginx >> $vagrant_build_log 2>&1

  echo -e "\n--- Backing up default nginx config ---\n"
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default_$(date +"%s").BAK

echo -e "\n--- Writing nginx config ---\n"
cat <<EOF > /etc/nginx/sites-available/default

upstream ${NAME}_upstream {
    server 127.0.0.1:$PORT;
    keepalive 64;
}

server {
    listen 80;
    server_name ${NAME}_server;
    root $SOURCE;
    
    location / {
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header Host \$http_host;
      proxy_set_header X-NginX-Proxy true;
      proxy_http_version 1.1;
      proxy_set_header Upgrade \$http_upgrade;
      proxy_set_header Connection "upgrade";
      proxy_max_temp_file_size 0;
      proxy_pass http://${NAME}_upstream/;
      proxy_redirect off;
      proxy_read_timeout 240s;
    }
}
EOF

echo -e "\n--- Restarting nginx ---\n"
  sudo systemctl restart nginx >> $vagrant_build_log 2>&1