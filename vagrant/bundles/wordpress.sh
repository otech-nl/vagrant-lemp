require php5 mysql
# as per https://help.ubuntu.com/community/WordPress
$INSTALL wordpress mysql-server
# vsftpd may be needed to install plugins

mv /var/www/html /var/www/html.orig
ln -s /usr/share/wordpress /var/www/html
chmod u=rwX,g=srX,o=rX -R /var/www

gzip -d /usr/share/doc/wordpress/examples/setup-mysql.gz
bash /usr/share/doc/wordpress/examples/setup-mysql -n $PROJECT $PROJECT.dev

LOCAL_DIR=/srv/www/wp-content/$PROJECT.dev
mkdir $LOCAL_DIR/upgrade
for DIR in /usr/share/wordpress /var/lib/wordpress $LOCAL_DIR
do
    echo "Setting permissions for $DIR"
    chown -R www-data:www-data $DIR
    chmod -R g+w $DIR
done

RESTART="$RESTART apache2"
