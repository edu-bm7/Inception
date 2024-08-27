#!/bin/bash

# Set shell script directives:
# - e: exit with non-zero value if any command inside script fails
# - x: output each and every command to stdout
set -xe

# If database isn't already configured
if [[ ! -d "/var/lib/mysql/$DB_NAME" ]]; then
    # Start the MariaDB server
    mysqld_safe --datadir='/var/lib/mysql' & sleep 1

    # Run mysql_secure_installation using expect
expect <<EOF
spawn mysql_secure_installation

expect "Enter current password for root (enter for none):"
send "$DB_ROOT_PASS\r"

expect "Switch to unix_socket authentication \[Y/n]"
send "n\r"

expect "Change the root password? \[Y/n\]"
send "n\r"

expect "Remove anonymous users? \[Y/n\]"
send "Y\r"

expect "Disallow root login remotely? \[Y/n\]"
send "Y\r"

expect "Remove test database and access to it? \[Y/n\]"
send "Y\r"

expect "Reload privilege tables now? \[Y/n\]"
send "Y\r"

expect eof
EOF

    # Creates a new database with the name specified in the .env file, if it doesn't already exists
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
    
    # Grants all privileges on all databases and tables to the root user
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "GRANT ALL PRIVILEGES ON *.* TO '$DB_ROOT_USER'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';"
    
    # Grants all privileges on WordPress' database to the common user, and set it's password
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PASS';"
    
    # Udate MariaDB's privilege table with the newly made changes
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e "FLUSH PRIVILEGES;"
    
    # Terminates MySQL daemon
    # This step is more of a good practice, the daemon will be started again in the exec line, anyways
    mysqladmin -u$DB_ROOT_USER -p$DB_ROOT_PASS shutdown
fi

exec mysqld --bind-address=mariadb