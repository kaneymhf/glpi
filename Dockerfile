FROM centos:7

LABEL Maintainer="Maykon Facincani <facincani.maykon@gmail.com>"
LABEL Description="GLPI 10.0.7 Container Apache 2.4 & PHP 8.2 based on CentOS Linux."

ENV GLPI_VERSION 10.0.7

ENV DB_HOST mariadb

ENV DB_PORT 3306

ENV DB_DATABASE glpi

ENV DB_USER glpi

ENV DB_PASSWORD glpi

ENV INSTALL 0

RUN curl 'https://setup.ius.io/' | sh 

RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm 
RUN yum -y install epel-release yum-utils

RUN yum-config-manager --enable remi-php82

RUN yum -y install \
		mod_php \
		php-cli \
		php-mysqlnd

RUN yum -y install \
		bzip2 \
		httpd mod_ssl \
	        php-common \
		php-json \
		php-mbstring \
		php-mysqli \
		php-session \
		php-gd \
		php-curl \
		php-domxml \
		php-imap \
		php-ldap \
		php-openssl \
		php-opcache \
		php-apcu \
		php-xmlrpc \
		php-intl \
	        php-pecl-apcu \
		php-snmp \
		php-soap \
		openssl \
		jq \
		zip \
		zlib \
		zlib-devel \
		php-pear-CAS \
		php-pear \
		php-devel \
		php-pecl-zip \
		httpd-devel \ 
		pcre-devel \ 
		gcc \ 
		make \
		wget \
	&& yum -y clean all \
	&& rm -rf /var/cache/yum

# Add Composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer

ADD php.d /etc/php.d

ADD conf.d /etc/httpd/conf.d

RUN wget https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz -P /tmp

RUN tar -zxvf /tmp/glpi-${GLPI_VERSION}.tgz -C /var/www/html/

COPY main.sh /root/main.sh
COPY .htaccess /root/.htaccess
COPY inc/downstream.php /var/www/html/glpi/inc/downstream.php
COPY inc/local_define.php /var/www/html/glpi/config/local_define.php
COPY .htaccess /var/www/html/glpi/.htaccess

RUN chmod 755 /root/main.sh

RUN chown apache:apache -R /var/www/html/glpi

RUN find /var/www/html/glpi/ -type f -exec chmod 644 {} \; 
RUN find /var/www/html/glpi/ -type d -exec chmod 775 {} \; 

RUN cp -rap /var/www/html/glpi/files /root/files
RUN cp -rap /var/www/html/glpi/plugins /root/plugins
RUN cp -rap /var/www/html/glpi/marketplace /root/marketplace
RUN cp -rap /var/www/html/glpi/config /root/config

EXPOSE 80/tcp 443/tcp

CMD [ "/root/main.sh" ]

HEALTHCHECK --interval=5s --timeout=3s CMD if [ ${INSTALL} -eq 0 ]; then curl --fail http://localhost:80/glpi || exit 1 fi 
