# LEMP Vagrant box

I created this Vagrant box for the following reasons:

* development of Python and PHP, with MySQL
* vanilla Ubuntu
* project agnostic (install project dependencies with pip, composer, bower, ...)
* no dependencies on a provisioner like Docker, Puppet, Ansible, ...
* completely unattended provisioning
* Keep It Small & Simple

## Prerequisites

All you need to get started is:

* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant](https://www.vagrantup.com/)

Then:

    git clone https://github.com/otech-nl/vagrant-lemp.git
    vagrant up

Wait until vagrant finishes and then open [http://192.168.33.10](http://192.168.33.10) or type `vagrant ssh`.

## Contents

This box uses [ubuntu/wily64](https://vagrantcloud.com/ubuntu/boxes/wily64) and additionally contains:

* nginx
* mysql
* php5-fpm
* composer
* phpmyadmin
* nodejs, npm, bower

## Details

* All configuration is done through variables in `vagrant/provision.sh`.
  * The `COMPONENTS` variable lets you select which components to install.
  * This is where you will find database names, passwords, etc. as well.
* You can set your VM name and host name in Vagrantfile
* your current directory is mapped to `/home/vagrant/public_html`
* [http://192.168.33.10](http://192.168.33.10) opens the default nginx page
* [http://192.168.33.10/~vagrant](http://192.168.33.10/~vagrant) opens your home page
* [http://192.168.33.10/phpmyadmin](http://192.168.33.10/phpmyadmin) opens PhpMyAdmin
* root password: vagrant
* MySQL is secured using `mysql_secure_installation`

## Caveat

The following error message is harmless and can be ignored:

    ==> default: mesg:
    ==> default: ttyname failed
    ==> default: :
    ==> default: Inappropriate ioctl for device

## Tip

Add the following line to your `C:\Windows\System32\drivers\etc\hosts` or `/etc/hosts` (depending on your host OS) to be able to use [vagrant.dev](http://vagrant.dev) as URL:

    192.168.33.10	vagrant.dev
