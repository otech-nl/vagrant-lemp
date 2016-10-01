# -*- mode: ruby -*-
# vi: set ft=ruby :
# https://github.com/otech-nl/vagrant-lemp

vmname = "lemp"

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/wily64"
  # the official box doesn't work
  # config.vm.box = "ubuntu/xenial64"
  # config.vm.box = "gbarbieru/xenial"
  config.vm.hostname = vmname
  config.vm.network "private_network", ip: "192.168.33.10"
  if defined?(VagrantPlugins::HostsUpdater)
    config.hostsupdater.aliases = ["vagrant.dev", vmname+".dev"]
    config.hostsupdater.remove_on_suspend = true
  end
  config.vm.synced_folder ".", "/home/vagrant/public_html"

  config.vm.provider "virtualbox" do |v|
    v.name = vmname
    # v.memory = 1024
  end

  config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  config.vm.provision "shell", path: "vagrant/provision.sh", args: vmname
end
