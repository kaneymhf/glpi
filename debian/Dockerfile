FROM php:7.3-apache-buster

LABEL Maintainer="Maykon Facincani <facincani.maykon@gmail.com>"
LABEL Description="GLPI Container Apache 2.4 & PHP-FPM 7.3 based on Debian Buster Linux."

# Update
RUN apt update
RUN apt install -y curl zip sudo

#### PHP Extensions

# GD
RUN apt -y install libpng-dev libfreetype6-dev libjpeg62-turbo-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd

# MYSQLI EXT
RUN docker-php-ext-install mysqli

# XMLRPC EXT
RUN apt install -y libxml2-dev 
RUN docker-php-ext-install xmlrpc

# APCU AND APCu-BC EXT
RUN pecl install apcu
RUN pecl install apcu_bc
RUN docker-php-ext-enable apcu
RUN docker-php-ext-enable apc

# IMAP EXT
RUN apt install -y libc-client-dev libkrb5-dev
RUN docker-php-ext-configure imap --with-imap --with-imap-ssl --with-kerberos
RUN docker-php-ext-install imap

# ZENDOPCACHE EXT
RUN apt install -y libpcre3-dev
RUN docker-php-ext-install opcache

# LDAP EXT
RUN apt-get install -y libldap2-dev
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
RUN docker-php-ext-install ldap

# SOAP EXT
RUN docker-php-ext-install soap

# SNMP EXT
RUN apt install -y libsnmp-dev
RUN docker-php-ext-install snmp

# EXIF EXT
RUN docker-php-ext-install exif

# INTL EXT
RUN apt install -y libicu-dev
RUN docker-php-ext-install intl

# CLEAN APT
RUN apt autoremove -y

RUN rm -rf /var/lib/apt/lists/*

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2

EXPOSE 80

RUN a2enmod rewrite

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN useradd uftm && echo "uftm:uftm" | chpasswd && adduser uftm sudo

CMD apache2 -DFOREGROUND