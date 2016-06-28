#!/usr/bin/env bash
###################################################
# Vagrant provisioning for a basic LEMP Box
# https://github.com/otech-nl/vagrant-lemp
###################################################

# select the components you want to be installed
COMPONENTS="nginx mysql php myadmin py2 symfony js cc flask"

# set your database values
DBHOST=localhost
DBNAME=vagrant
DBUSER=vagrant
DBPASSWD=vagrant
TIMEZONE=Europe/Amsterdam

###################################################
# you probably do not want to edit below this line
###################################################

export DEBIAN_FRONTEND=noninteractive
APPENV=local
INSTALL="apt-get install -yq"
VAGRANT_DIR=/home/vagrant/public_html/vagrant

report() {
    echo "####################################################"
    echo $1
    echo "####################################################"
}

# install packages
report "Updating package database"
apt-get update
$INSTALL cloc

if [[ $COMPONENTS =~ "nginx" ]]; then
    report "Installing package nginx"
    $INSTALL nginx
    rm /etc/nginx/sites-available/default
    ln -s $VAGRANT_DIR/nginx.conf /etc/nginx/sites-available/default
fi

if [[ $COMPONENTS =~ "mysql" ]]; then
    report "Installing MySQL"
    echo "mysql-server mysql-server/root_password password $DBPASSWD" | debconf-set-selections
    echo "mysql-server mysql-server/root_password_again password $DBPASSWD" | debconf-set-selections
    $INSTALL -q mysql-server
    . $VAGRANT_DIR/mysql_secure.sh $DBPASSWD
    mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME"
    mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD'"
fi

if [[ $COMPONENTS =~ "php" ]]; then
    report "Installing PHP"
    $INSTALL php5-fpm composer
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

if [[ $COMPONENTS =~ "symfony" ]]; then
    report "Configuring Symfony"
    curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
    chmod a+x /usr/local/bin/symfony
    ln -s $VAGRANT_DIR/symfony.conf /etc/nginx/sites-enabled
    $INSTALL php-xml php-intl
fi

if [[ $COMPONENTS =~ "py2" ]]; then
    report "Installing Python components"
    $INSTALL virtualenv python-pip python-dev
    if [[ $COMPONENTS =~ "mysql" ]]; then
        $INSTALL libmysqlclient-dev
    fi
fi

if [[ $COMPONENTS =~ "flask" ]]; then
    report "Configuring Flask"
    $INSTALL uwsgi uwsgi-plugin-python
    ln -s $VAGRANT_DIR/flask.ini /etc/uwsgi/apps-enabled
    ln -s $VAGRANT_DIR/uwsgi.conf /etc/nginx/sites-enabled
    mkdir /var/www/.python-eggs
    chown www-data:www-data /var/www/.python-eggs/
    service uwsgi restart
fi

if [[ $COMPONENTS =~ "cc" ]]; then
    report "Installing C components"
    $INSTALL valgrind astyle libglib2.0-dev
fi

if [[ $COMPONENTS =~ "js" ]]; then
    report "Installing Javascript components"
    $INSTALL npm
    npm install bower -g
    ln -s /usr/bin/nodejs /usr/local/bin/node
fi

# post install actions
report "Finishing up"
ln -s $VAGRANT_DIR/bash_prompt.sh /home/vagrant/.bash_prompt
echo $TIMEZONE > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
echo ". ~/.bash_prompt" >>/home/vagrant/.bashrc
echo ". venv/bin/activate" >>/home/vagrant/.bashrc
if [[ $COMPONENTS =~ "nginx" ]]; then
    service nginx restart
fi
if [[ $COMPONENTS =~ "php" ]]; then
    service php5-fpm restart
fi
