# This script creates a new CakePHP project.
cd public_html
composer create-project --prefer-dist -s dev cakephp/app cake
cd cake
composer install
echo "Remember to correct Datasources in config/app.php"
echo "Remember to set 'root /home/vagrant/public_html/cake/webroot' in you nginx configuration"