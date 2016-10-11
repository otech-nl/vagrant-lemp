cd public_html
composer create-project --prefer-dist -s dev cakephp/app cake
cd cake
composer install
echo "Remember to correct Datasources in config/app.php"