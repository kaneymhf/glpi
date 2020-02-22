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

composer install -d=/var/www/html/glpi

if [ $IS_INSTALLED -eq 1 ];
then
    rm -rf /var/www/html/glpi/install
fi

/usr/sbin/httpd -DFOREGROUND