# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

SUBNAME="192.168.1"
DOMAIN="testvm.local"

WEBNAME="webnginx"
WEBIP="#{SUBNAME}.2"

DBNAME="mysqldb"
DBIP="#{SUBNAME}.3"


Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "centos/8"
  config.vbguest.installer_options = { allow_kernel_upgrade: true }
  config.vbguest.auto_update = true

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  # config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  config.vm.provider "virtualbox" do |vb|  
    # Customize the amount of memory on the VM:
    vb.memory = "1024"
    vb.cpus = "1"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  config.vm.define :mysqldb do |mdb|
    mdb.vm.hostname = "#{DBNAME}.#{DOMAIN}"
    mdb.vm.network :private_network, ip: "#{DBIP}"
    mdb.vm.provision "shell", path: "scripts/install-puppet.sh"
    mdb.vm.provision "puppet" do |puppet|
      puppet.manifest_file = "init.pp"
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path = "puppet/modules"
      # puppet.options = "--verbose --debug"
    end
  end

  config.vm.define :webnginx do |web|
    web.vm.hostname = "#{WEBNAME}.#{DOMAIN}"
    web.vm.network :private_network, ip: "#{WEBIP}"
    web.vm.provision "shell", path: "scripts/install-puppet.sh"
    web.vm.provision "puppet" do |puppet|
      puppet.manifest_file = "init.pp"
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path = "puppet/modules"
      # puppet.options = "--verbose --debug"
    end
  end
end
