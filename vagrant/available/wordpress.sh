# as per https://help.ubuntu.com/community/WordPress
$INSTALL wordpress mysql-server vsftpd
# ftp is needed to install plugins

chown -R www-data /usr/share/wordpress

mv /var/www/html /var/www/html.orig
ln -s /usr/share/wordpress /var/www/html
chmod u=rwX,g=srX,o=rX -R /var/www

gzip -d /usr/share/doc/wordpress/examples/setup-mysql.gz
bash /usr/share/doc/wordpress/examples/setup-mysql -n $1 $1.dev
RESTART="$RESTART apache2"

# make plugins dir accessible
LOCAL_DIR=/srv/www/wp-content/$1.dev
mkdir $LOCAL_DIR/upgrade
chown -R www-data:www-data $LOCAL_DIR
