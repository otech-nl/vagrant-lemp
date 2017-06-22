require base
$INSTALL nginx
rm /etc/nginx/sites-available/default
ln -s $CFG_DIR/nginx.conf /etc/nginx/sites-available/default
RESTART="$RESTART nginx"
