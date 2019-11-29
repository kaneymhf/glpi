FROM centos:7

LABEL Maintainer="Maykon Facincani <facincani.maykon@gmail.com>"
LABEL Description="GLPI Container Apache 2.4 & PHP 7.3 based on CentOS Linux."

ENV DB_HOST mariadb

ENV DB_PORT 3306

ENV DB_DATABASE glpi

ENV DB_USER glpi

ENV DB_PASSWORD glpi

ENV IS_INSTALLED 0

RUN curl 'https://setup.ius.io/' | sh 

RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm 
RUN yum -y install epel-release yum-utils

RUN yum-config-manager --enable remi-php73

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
		php-pear-CAS \
		php-pear \
		php-devel \
		httpd-devel \ 
		pcre-devel \ 
		gcc \ 
		make \
	&& yum -y clean all \
	&& rm -rf /var/cache/yum

ADD php.d /etc/php.d

ADD conf.d /etc/httpd/conf.d

ADD html /var/www/html

COPY main.sh /root/main.sh

RUN chmod 755 /root/main.sh

EXPOSE 80/tcp 443/tcp

CMD ["/root/main.sh"]