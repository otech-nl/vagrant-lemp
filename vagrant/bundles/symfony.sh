require python
curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
chmod a+x /usr/local/bin/symfony
ln -s $CFG_DIR/symfony.conf /etc/nginx/sites-enabled/$PROJECT.conf
$INSTALL php-xml php-intl
