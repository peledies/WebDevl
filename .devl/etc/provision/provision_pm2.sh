#!/bin/bash

# Arguments
SOURCE=${1:-/opt/local_marketing_insights}
NAME=${2:-"local-marketing-insights"}
ENTRY=${3:-"source/index.js"}
ENV=${4:-"development"}
CONFIG=${5:-local-mysql}

vagrant_build_log=/home/ubuntu/vm_build.log

echo -e "\n================================\n=== Provisioning PM2 Service ===\n================================\n"

echo -e "\n--- Changing ownership of file [${vagrant_build_log}] -> [ubuntu:ubuntu] ---\n"
  sudo chown ubuntu:ubuntu $vagrant_build_log

echo -e "\n--- Installing NPM App Dependencies ---\n"
  cd $SOURCE
  # express . -f >> $vagrant_build_log 2>&1
  npm install >> $vagrant_build_log 2>&1

echo -e "\n--- Installing PM2 to run node app as daemon ---\n"
  sudo npm install -g pm2 >> $vagrant_build_log 2>&1

echo -e "\n--- Configuring PM2 ---\n"
cat <<EOF > $SOURCE/pm2.config.js
module.exports = {
  /**
   * Application configuration section
   * http://pm2.keymetrics.io/docs/usage/application-declaration/
   */
  apps : [

    // First application
    {
      name      : '${NAME}',
      script    : '${SOURCE}/${ENTRY}',
      env: {
        DB_CONFIG : '${CONFIG}',
        NODE_ENV: '${ENV}'
      },
      env_production : {
        NODE_ENV: 'production'
      }
    },
  ],

};
EOF

pm2 start $SOURCE/pm2.config.js >> $vagrant_build_log 2>&1

sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu >> $vagrant_build_log 2>&1

pm2 save >> $vagrant_build_log 2>&1

echo -e "\n--- Restarting nginx ---\n"
  sudo systemctl restart nginx >> $vagrant_build_log 2>&1