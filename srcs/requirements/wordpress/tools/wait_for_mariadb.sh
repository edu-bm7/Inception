#!/bin/bash
until mysql -h mariadb -u$DB_USER -p$DB_USER_PASS -e "SHOW DATABASES;" > /dev/null 2>&1; do
  echo "Waiting for MariaDB to be ready..."
  sleep 10
done