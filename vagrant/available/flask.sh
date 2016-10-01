$INSTALL uwsgi uwsgi-plugin-python
ln -s $CFG_DIR/flask.ini /etc/uwsgi/apps-enabled/$PROJECT.ini
ln -s $CFG_DIR/uwsgi.conf /etc/nginx/sites-enabled/$PROJECT.conf
mkdir /var/www/.python-eggs
chown www-data:www-data /var/www/.python-eggs/
service uwsgi restart
