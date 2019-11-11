FROM php:7.2-apache-stretch

MAINTAINER Maykon H Facincani <maykon.facincani@uftm.edu.br>
LABEL version="1.0"
LABEL description="Apache2 with PHP7.2 and extensions"

RUN apt-get update && apt-get -y upgrade

RUN apt-get -f install -y curl zip sudo libapache2-mod-security2 --no-install-recommends

RUN apt -f install -y --no-install-recommends cron 

# ZIP EXT
RUN apt install -y zlib1g-dev
RUN docker-php-ext-install zip
RUN apt remove -y zlib1g-dev && apt-get install -y zlib1g

# INTL EXT
RUN apt install -y libicu-dev
RUN docker-php-ext-install intl

# GD EXT
RUN apt -y install libpng-dev libfreetype6-dev libjpeg62-turbo-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd

# IMAGICK EXT
RUN apt install -y libmagickwand-dev
RUN pecl install imagick
RUN docker-php-ext-enable imagick
#RUN echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini

# MCRYPT EXT
RUN apt install -y libmcrypt-dev
RUN pecl install mcrypt-1.0.1
RUN docker-php-ext-enable mcrypt

# LDAP EXT
RUN apt-get install -y libldap2-dev
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
RUN docker-php-ext-install ldap

# MYSQLI
RUN docker-php-ext-install mysqli

# GETTEXT EXT
RUN docker-php-ext-install gettext

# XMLRPC EXT
RUN docker-php-ext-install xmlrpc

# APCU AND APCu-BC EXT
RUN pecl install apcu
RUN pecl install apcu_bc
RUN docker-php-ext-enable apcu
RUN docker-php-ext-enable apc

# SOAP EXT
RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install soap

# IMAP EXT
RUN apt install -y libc-client-dev libkrb5-dev
RUN docker-php-ext-configure imap --with-imap --with-imap-ssl --with-kerberos
RUN docker-php-ext-install imap

# SNMP EXT
RUN apt install -y libsnmp-dev
RUN docker-php-ext-install snmp

# PDO EXT
RUN docker-php-ext-install pdo

# PDO_MYSQL EXT
RUN docker-php-ext-install pdo_mysql

# PDO_PGSQL EXT
RUN apt install -y libpq-dev
RUN docker-php-ext-install pdo_pgsql

# OPCACHE
RUN apt install -y libpcre3-dev
RUN docker-php-ext-install opcache

# EXIF
RUN apt-get -yqq update
RUN apt-get -yqq install exiftool
RUN docker-php-ext-configure exif
RUN docker-php-ext-install exif
RUN docker-php-ext-enable exif

# CAS
ADD phpcas.tar.gz /root/phpcas.tar.gz
RUN pear install /root/phpcas.tar.gz

# CLEAN APT
RUN apt autoremove -y

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2


RUN mkdir /etc/apache2/ssl

EXPOSE 80
EXPOSE 443

ADD ssl/stic.crt  /etc/apache2/ssl/stic.crt
ADD ssl/stic.key  /etc/apache2/ssl/stic.key

RUN a2enmod rewrite ssl headers

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN useradd uftm && echo "uftm:uftm" | chpasswd && adduser uftm sudo

CMD apache2 -DFOREGROUND
