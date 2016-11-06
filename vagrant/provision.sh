#!/usr/bin/env bash
###################################################
# Vagrant provisioning for a basic LEMP Box
# https://github.com/otech-nl/vagrant-lemp
###################################################

PROJECT=$1
USERNAME=$2

# set your database values
DBHOST=localhost
DBNAME=$PROJECT
DBUSER=vagrant
DBPASSWD=vagrant
TIMEZONE=Europe/Amsterdam

###################################################
# you probably do not want to edit below this line
###################################################

export DEBIAN_FRONTEND=noninteractive
APPENV=local
INSTALL="apt-get install -yq"
HOME_DIR=/home/$USERNAME
VAGRANT_DIR=$HOME_DIR/public_html/vagrant
CFG_DIR=$VAGRANT_DIR/cfg

report() {
    echo "####################################################"
    echo $1
    echo "####################################################"
}

# install packages
report "Provisioning $PROJECT"
adduser $USERNAME www-data
report "Updating package database"
apt-get update
apt-get -y autoremove

RESTART=""
for SCRIPT in $VAGRANT_DIR/enabled/*.sh
do
    if [ -f $SCRIPT ]
    then
        NAME=`basename $SCRIPT .sh`
        report "Running $NAME installation script"
        . $SCRIPT $PROJECT
    fi
done

# restart services as needed
RESTART=`echo $RESTART | xargs -n1 | sort -u`
for SERVICE in $RESTART
do
    echo "restarting service $SERVICE"
    service $SERVICE restart
done

report "Applying user setup"
PROMPT=$HOME_DIR/.bash_prompt
if [ ! -h $PROMPT ]
then
    ln -s $CFG_DIR/bash_prompt.sh $PROMPT
    echo ". ~/.bash_prompt" >>$HOME_DIR/.bashrc
fi
SETUP=$VAGRANT_DIR/setup.sh
if [ ! -e $SETUP ]
then
    echo "Running $SETUP"
    sudo -u $USERNAME bash $SETUP
fi

# final tweaks
report "Finishing up"
$INSTALL cloc

# set timezone
echo $TIMEZONE > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

