# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/xenial64"
  
  # Prevent "Inappropriate ioctl for device" message
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.define :lmi do |lmi|
  end

  # We have to use port 3000 because it is whitelisted by Auth0
  config.vm.network :forwarded_port, host: 3000, guest: 80
  config.vm.network :forwarded_port, host: 33068, guest: 3306

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end

  config.vm.synced_folder "./", "/opt/local_marketing_insights", owner: "www-data", group: "www-data", mount_options: ["dmode=777", "fmode=777"]

  # General server provisioning
  config.vm.provision "shell" do |s|
    s.path = "./.devl/etc/scripts/provision_general.sh"
  end

  # Git remote provisioning
  config.vm.provision "shell" do |s|
    s.path = "./.devl/etc/scripts/provision_git_remote.sh"
    s.args = "lmi sfp.cc /opt/local_marketing_insights"
  end

  # MySql server provisioning
  config.vm.provision "shell" do |s|
    s.path = "./.devl/etc/scripts/provision_mysql.sh"
    s.args = "lmi SECRET"
  end

  # Nginx Reverse Proxy provisioning
  config.vm.provision "shell" do |s|
    s.path = "./.devl/etc/scripts/provision_nginx_rev_proxy.sh"
    s.args = "/opt/local_marketing_insights local_marketing_insights 3000"
  end

  # NodeJS server provisioning
  config.vm.provision "shell" do |s|
    s.path = "./.devl/etc/scripts/provision_node.sh"
  end

  # Provision node pm2 for upstart
  config.vm.provision "shell" do |s|
    s.privileged = false
    s.path = "./.devl/etc/scripts/provision_pm2.sh"
    s.args = "/opt/local_marketing_insights local-marketing-insights source/index.js development local-mysql"
  end

end
