# some provisioning that should probably always run
$INSTALL cloc git

adduser $USERNAME www-data

echo $TIMEZONE > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
