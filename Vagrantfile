# -*- mode: ruby -*-
# vi: set ft=ruby :
# https://github.com/otech-nl/vagrant-lemp

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/wily64"
  config.vm.hostname = "lemp"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder ".", "/home/vagrant/public_html"

  config.vm.provider "virtualbox" do |v|
    v.name = "lemp"
  end

  config.vm.provision "file", source: "vagrant/bash_prompt.sh", destination: "/tmp/bash_prompt.sh"
  config.vm.provision "file", source: "vagrant/mysql_secure.sh", destination: "/tmp/mysql_secure.sh"
  config.vm.provision "file", source: "vagrant/nginx.conf", destination: "/tmp/nginx.conf"
  config.vm.provision "shell", path: "vagrant/provision.sh"
end
