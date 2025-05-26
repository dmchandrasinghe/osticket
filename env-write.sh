#!/bin/bash

# Check and copy default config if ost-config.php doesn't exist
if [ ! -f /var/www/html/include/ost-config.php ]; then
    cp /var/www/html/include/default-ost-config.php /var/www/html/include/ost-config.php
    chown www-data:www-data /var/www/html/include/ost-config.php
    chmod 644 /var/www/html/include/ost-config.php
fi

# Replace database configuration
sed -i "s/%CONFIG-DBHOST/${MYSQL_HOST}/" /var/www/html/include/ost-config.php
sed -i "s/%CONFIG-DBNAME/${MYSQL_DATABASE}/" /var/www/html/include/ost-config.php
sed -i "s/%CONFIG-DBUSER/${MYSQL_USER}/" /var/www/html/include/ost-config.php
sed -i "s/%CONFIG-DBPASS/${MYSQL_PASSWORD}/" /var/www/html/include/ost-config.php

# Set admin email
sed -i "s/%ADMIN-EMAIL/${ADMIN_USERNAME}/" /var/www/html/include/ost-config.php

# Set secret salt
if [ ! -z "${INSTALL_SECRET}" ]; then
    sed -i "s/%CONFIG-SIRI/${INSTALL_SECRET}/" /var/www/html/include/ost-config.php
fi

# Set table prefix (if provided in environment)
if [ ! -z "${TABLE_PREFIX}" ]; then
    sed -i "s/%CONFIG-PREFIX/${TABLE_PREFIX}/" /var/www/html/include/ost-config.php
else
    # Default prefix if not specified
    sed -i "s/%CONFIG-PREFIX/ost_/" /var/www/html/include/ost-config.php
fi

# Enable installation
if [ ! -z "${OSTINSTALLED}" ]; then
    sed -i "s/define('OSTINSTALLED',FALSE);/define('OSTINSTALLED',TRUE);/" /var/www/html/include/ost-config.php
fi
# Set proper permissions
chown www-data:www-data /var/www/html/include/ost-config.php
chmod 644 /var/www/html/include/ost-config.php

# Start Apache
apache2-foreground