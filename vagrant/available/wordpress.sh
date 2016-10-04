# as per https://help.ubuntu.com/community/WordPress
$INSTALL wordpress mysql-server
mv /var/www/html /var/www/html.orig
ln -s /usr/share/wordpress /var/www/html
gzip -d /usr/share/doc/wordpress/examples/setup-mysql.gz
bash /usr/share/doc/wordpress/examples/setup-mysql -n $1 $1.dev
service apache2 restart