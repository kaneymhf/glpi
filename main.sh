#!/bin/bash
#
set -x
#

{
    echo "<?php"; \
    echo "class DB extends DBmysql {"; \
    echo "   public \$dbhost     = '${DB_HOST}:${DB_PORT}';"; \
    echo "   public \$dbuser     = '${DB_USER}';"; \
    echo "   public \$dbpassword = '${DB_PASSWORD}';"; \
    echo "   public \$dbdefault  = '${DB_DATABASE}';"; \
    echo "}"; \
    echo ;
 } > /var/www/html/glpi/config/config_db.php

if [ $IS_INSTALLED -eq 1 ];
then
    rm -rf /var/www/html/glpi/install
fi


if [ -z "$(ls -A /var/www/html/glpi/files)" ]; then
    cp -rap /root/files /var/www/html/glpi

    chown apache:apache -R /var/www/html/glpi/files

    find /var/www/html/glpi/files -type f -exec chmod 644 {} \;
    find /var/www/html/glpi/files -type d -exec chmod 775 {} \;
fi

if [ -z "$(ls -A /var/www/html/glpi/plugins)" ]; then
    cp -rap /root/plugins /var/www/html/glpi

    chown apache:apache -R /var/www/html/glpi/plugins

    find /var/www/html/glpi/plugins -type f -exec chmod 644 {} \;
    find /var/www/html/glpi/plugins -type d -exec chmod 775 {} \;
fi

if [ -z "$(ls -A /var/www/html/glpi/marketplace)" ]; then
    cp -rap /root/marketplace /var/www/html/glpi

    chown apache:apache -R /var/www/html/glpi/marketplace

    find /var/www/html/glpi/marketplace -type f -exec chmod 644 {} \;
    find /var/www/html/glpi/marketplace -type d -exec chmod 775 {} \;
fi


if [ -z "$(ls -A /var/www/html/glpi/config)" ]; then
    cp -rap /root/plugins /var/www/html/config

    chown apache:apache -R /var/www/html/glpi/config

    find /var/www/html/glpi/config -type f -exec chmod 644 {} \;
    find /var/www/html/glpi/config -type d -exec chmod 775 {} \;
fi


/usr/sbin/httpd -DFOREGROUND
