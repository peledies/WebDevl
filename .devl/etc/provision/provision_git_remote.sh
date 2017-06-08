#!/bin/bash

# Arguments
SHORTNAME=${1:-"lmi"}
DOMAIN=${2:-"sfp.cc"}
SOURCE=${3:-"/opt/local_marketing_insights"}
URL="$SHORTNAME.$DOMAIN"

vagrant_build_log=/home/ubuntu/vm_build.log

echo -e "\n==================================\n=== Provisioning As Git Remote ===\n==================================\n"

## Create a bare git repo on this machine
echo -e "\n--- Creating bare git repository ---\n"
  mkdir -p /git/${SHORTNAME}.git >> $vagrant_build_log 2>&1

echo -e "\n--- Initializing git repository ---\n"
  cd /git/${SHORTNAME}.git >> $vagrant_build_log 2>&1
  git init --bare >> $vagrant_build_log 2>&1

## Update permissions so changes can be pushed via git
echo -e "\n--- Updating permissions for git repository ---\n"
  chown -R ubuntu:ubuntu /git >> $vagrant_build_log 2>&1

## Create directory structure for site
echo -e "\n--- Creating directory structure for project ---\n"
  mkdir -p $SOURCE >> $vagrant_build_log 2>&1

echo -e "\n--- Cloning repository into virtualhost directory$ ---\n"
  cd $SOURCE >> $vagrant_build_log 2>&1
  git clone /git/${SHORTNAME}.git . >> $vagrant_build_log 2>&1


## Configure git post-receive hooks to force a checkout on the project
echo -e "\n--- Creating post-receive hooks for git repository ---\n"
cat <<EOF > /git/$SHORTNAME.git/hooks/post-receive
#!/bin/bash

echo "---" \$(date) "---" >> /tmp/$SHORTNAME-git-pull.log
unset GIT_DIR 2>> /tmp/$SHORTNAME-git-pull.log

cd $SOURCE
git fetch --all 2>> /tmp/$SHORTNAME-git-pull.log

git checkout -f dev 2>> /tmp/$SHORTNAME-git-pull.log

git reset --hard origin/dev 2>> /tmp/$SHORTNAME-git-pull.log
EOF

echo -e "\n--- Making post-receive hook executable ---\n"
  chmod +x /git/$SHORTNAME.git/hooks/post-receive >> $vagrant_build_log 2>&1
