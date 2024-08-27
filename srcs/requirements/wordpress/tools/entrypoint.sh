#!/bin/bash

# Wait for MariaDB be configured before setup WordPress
/usr/local/bin/wait_for_mariadb.sh

if [[ ! -f "/var/www/html/wp-config.php" ]]; then
	echo "Downloading WP-CLI so we can work with WordPress through the CLI..."
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
    echo "Updating WP-CLI..."
    wp cli update --yes
	echo "Downloading WordPress..."
	wp core download --path=$WP_PATH --allow-root
    echo "Setting up WordPress..."
	wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_USER_PASS \
		--dbhost=mariadb --path=$WP_PATH --skip-check --allow-root
	wp core install --path=$WP_PATH --url=$DOMAIN_NAME --title=Inception \
		--admin_user=$WP_ADM_USER --admin_password=$WP_ADM_PASS \
		--admin_email=$WP_ADM_EMAIL --skip-email --allow-root
	wp user create $WP_USER $WP_EMAIL --user_pass=$WP_PASS \
		--role=author --allow-root
	echo "Done!"
fi

echo "Running wordpress on port 9000..."
/usr/sbin/php-fpm7.4 -F