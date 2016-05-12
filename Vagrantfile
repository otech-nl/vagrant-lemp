# -*- mode: ruby -*-
# vi: set ft=ruby :
# https://github.com/otech-nl/vagrant-lemp

vmname = "lemp"

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/wily64"
  # config.vm.box = "ubuntu/xenial64"
  # the official box doesn't work
  # config.vm.box = "gbarbieru/xenial"
  config.vm.hostname = vmname
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.synced_folder ".", "/home/vagrant/public_html"

  config.vm.provider "virtualbox" do |v|
    v.name = vmname
  end

  for f in "bash_prompt.sh mysql_secure.sh nginx.conf flask.conf symfony.conf flask.ini".split(" ")
    config.vm.provision "file", source: "vagrant/#{f}", destination: "/tmp/#{f}"
  end
  config.vm.provision "shell", path: "vagrant/provision.sh"
end
