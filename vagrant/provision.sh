#!/usr/bin/env bash
###################################################
# Vagrant provisioning for a basic LEMP Box
# https://github.com/otech-nl/vagrant-lemp
###################################################

PROJECT=$1

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
VAGRANT_DIR=/home/vagrant/public_html/vagrant
CFG_DIR=$VAGRANT_DIR/cfg

report() {
    echo "####################################################"
    echo $1
    echo "####################################################"
}

# install packages
report "Provisioning $PROJECT"
report "Updating package database"
apt-get update
apt-get autoremove

for SCRIPT in $VAGRANT_DIR/enabled/*
do
    if [ -f $SCRIPT ]
    then
        NAME=`basename $SCRIPT .sh`
        report "Running $NAME"
        . $SCRIPT
    fi
done

# post install actions
report "Finishing up"
$INSTALL cloc
PROMPT=/home/vagrant/.bash_prompt
if [ ! -h $PROMPT ]
then
    ln -s $CFG_DIR/bash_prompt.sh $PROMPT
    echo ". ~/.bash_prompt" >>/home/vagrant/.bashrc
fi
echo $TIMEZONE > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
