export DEBIAN_FRONTEND=noninteractive

# Variables
APPENV=local
DBHOST=localhost
DBNAME=vagrant
DBUSER=vagrant
DBPASSWD=vagrant

# set configuration values
echo "mysql-server mysql-server/root_password password $DBPASSWD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections

# install packages
apt-get update
apt-get install -y nginx
apt-get install -y -q mysql-server
apt-get install -y php5-fpm
apt-get install -y composer
apt-get install -y -q phpmyadmin

# post install actions
mv /tmp/nginx.conf /etc/nginx/sites-available/default
. /tmp/mysql_secure.sh $DBPASSWD
mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME"
mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD'"
service nginx restart
service php5-fpm restart

