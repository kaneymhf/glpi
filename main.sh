#!/bin/bash
#
set -x
#

/usr/libexec/httpd-ssl-gencerts

if [ -z "$(ls -A /etc/glpi)" ]; then
    cp -rap /root/config/* /etc/glpi/.
fi

if [ -z "$(ls -A /var/lib/glpi/files)" ]; then
    cp -rap /root/files /var/lib/glpi
fi

if [ $INSTALL -eq 0 ]; then
    rm -rf /var/www/html/glpi/install
fi

# if [ -z "$(ls -A /var/www/html/glpi/plugins)" ]; then
#     cp -rap /root/plugins /var/www/html/glpi

#     chown apache:apache -R /var/www/html/glpi/plugins

#     find /var/www/html/glpi/plugins -type f -exec chmod 644 {} \;
#     find /var/www/html/glpi/plugins -type d -exec chmod 775 {} \;
# fi

# if [ -z "$(ls -A /var/www/html/glpi/marketplace)" ]; then
#     cp -rap /root/marketplace /var/www/html/glpi

#     chown apache:apache -R /var/www/html/glpi/marketplace

#     find /var/www/html/glpi/marketplace -type f -exec chmod 644 {} \;
#     find /var/www/html/glpi/marketplace -type d -exec chmod 775 {} \;
# fi

setenforce 0
/usr/sbin/httpd -DFOREGROUND
