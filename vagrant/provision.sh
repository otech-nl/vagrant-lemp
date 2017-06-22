#!/usr/bin/env bash
###################################################
# Vagrant provisioning for a basic LEMP Box
# https://github.com/otech-nl/vagrant-lemp
###################################################

PROJECT=$1
USERNAME=$2
BUNDLES="wordpress"

# set your database values
DBHOST=localhost
DBNAME=$PROJECT
DBUSER=$USERNAME
DBPASSWD=vagrant
TIMEZONE=Europe/Amsterdam

###################################################
# you probably do not want to edit below this line
###################################################

export DEBIAN_FRONTEND=noninteractive
APPENV=local
INSTALL="apt-get install -yq"
HOME_DIR=/home/$USERNAME
VAGRANT_DIR=/home/$USERNAME/public_html/vagrant
CFG_DIR=$VAGRANT_DIR/cfg
BUNDLES_DIR=$VAGRANT_DIR/bundles

report() {
    echo "####################################################"
    echo $1
    echo "####################################################"
}

INSTALLED=""
require() {
    for BUNDLE in $*
    do
        SCRIPT="$BUNDLES_DIR/$BUNDLE.sh"
        if [ -f $SCRIPT ]
        then
            if [[ $INSTALLED != *$BUNDLE* ]]
            then
                report "Running $BUNDLE installation script"
                . $SCRIPT
                INSTALLED = "$INSTALLED $BUNDLE"
                report "$BUNDLE installation script finished"
            fi
        else
            report "Script $SCRIPT does not exist!!!"
        fi
    done
}


# install packages
report "Provisioning $PROJECT"
report "Updating package database"
apt-get update
apt-get -y autoremove

RESTART=""
require $BUNDLES

report "Restarting services as needed"
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
if [ -f $SETUP ]
then
    echo "Running $SETUP"
    sudo -u $USERNAME bash $SETUP
fi
