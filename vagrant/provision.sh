#!/usr/bin/env bash
###################################################
# Vagrant provisioning for a basic LEMP Box
# https://github.com/otech-nl/vagrant-lemp
###################################################

# select the components you want to be installed
COMPONENTS="mysql php myadmin py js"

# set your database values
DBHOST=localhost
DBNAME=vagrant
DBUSER=vagrant
DBPASSWD=vagrant

###################################################
# you probably do not want to edit below this line
###################################################

export DEBIAN_FRONTEND=noninteractive
APPENV=local
INSTALL="apt-get install -y"

report() {
    echo "####################################################"
    echo $1
    echo "####################################################"
}

# install packages
report "Updating package database"
apt-get update

if [[ $COMPONENTS =~ "nginx" ]]; then
    report "Updating package nginx"
    $INSTALL nginx
    mv /tmp/nginx.conf /etc/nginx/sites-available/default
fi

if [[ $COMPONENTS =~ "mysql" ]]; then
    report "Installing MySQL"
    echo "mysql-server mysql-server/root_password password $DBPASSWD" | debconf-set-selections
    echo "mysql-server mysql-server/root_password_again password $DBPASSWD" | debconf-set-selections
    $INSTALL -q mysql-server
    . /tmp/mysql_secure.sh $DBPASSWD
    mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME"
    mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD'"
fi

if [[ $COMPONENTS =~ "php" ]]; then
    report "Installing PHP"
    $INSTALL php5-fpm
    $INSTALL composer
fi

if [[ $COMPONENTS =~ "myadmin" ]]; then
    report "Installing phpMyAdmin"
    echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
    echo "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD" | debconf-set-selections
    echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD" | debconf-set-selections
    echo "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD" | debconf-set-selections
    echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections
    $INSTALL -q phpmyadmin
fi

if [[ $COMPONENTS =~ "py" ]]; then
    report "Installing Python components"
    $INSTALL virtualenv
fi

if [[ $COMPONENTS =~ "js" ]]; then
    report "Installing Javascript components"
    $INSTALL npm
    npm install bower -g
    ln -s /usr/bin/nodejs /usr/local/bin/node
fi

# post install actions
report "Finishing up"
mv /tmp/bash_prompt.sh /home/vagrant/.bash_prompt
echo ". ~/.bash_prompt" >>/home/vagrant/.bashrc
if [[ $COMPONENTS =~ "nginx" ]]; then
    service nginx restart
fi
if [[ $COMPONENTS =~ "php" ]]; then
    service php5-fpm restart
fi
