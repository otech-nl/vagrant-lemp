# LEMP Vagrant box

I created this Vagrant box for the following reasons:

* development with Python or PHP, and MySQL
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

This box uses [ubuntu/wily64](https://vagrantcloud.com/ubuntu/boxes/wily64) and optionally contains:

* nginx
* mysql
* php (php5-fpm, composer)
* myadmin (phpmyadmin)
* py (virtualenv)
* js (nodejs, npm, bower)
* cc (valgrind, glib)

## Details

* You can enable components by copying their files from vagrant/available to vagrant/enabled
* You can set your VM name and host name in Vagrantfile. This name is also used as your project name. By default the name is derived from your directory name.
* Your current directory is mapped to `/home/vagrant/public_html`
* The script optionally uses the [HostsUpdater](https://github.com/cogitatio/vagrant-hostsupdater) plugin to set hostnames vagrant.dev and _<projectname>_.dev. Otherwise add the following line to your `C:\Windows\System32\drivers\etc\hosts` or `/etc/hosts` (depending on your host OS) to be able to use [vagrant.dev](http://vagrant.dev) as URL:

        192.168.33.10	vagrant.dev
* Useful pages:
   * [http://192.168.33.10](http://192.168.33.10) opens the default nginx page
   * [http://192.168.33.10/~vagrant](http://192.168.33.10/~vagrant) opens your home page
   * [http://192.168.33.10/phpmyadmin](http://192.168.33.10/phpmyadmin) opens PhpMyAdmin
* root password: vagrant
* MySQL is secured using `mysql_secure_installation`

