![Docker Pulls](https://img.shields.io/docker/pulls/kaneymhf/docker-glpi) [![](https://images.microbadger.com/badges/image/kaneymhf/docker-glpi.svg)](https://microbadger.com/images/kaneymhf/docker-glpi "Get your own image badge on microbadger.com") ![Docker Stars](https://img.shields.io/docker/stars/kaneymhf/docker-glpi) [![](https://images.microbadger.com/badges/version/kaneymhf/docker-glpi.svg)](https://microbadger.com/images/kaneymhf/docker-glpi "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/license/kaneymhf/docker-glpi.svg)](https://microbadger.com/images/kaneymhf/docker-glpi "Get your own license badge on microbadger.com")

# Docker GLPI

This images contains an instance of GLPI version 9.4.5 served by apache 2.4 and php 7.3 on port 80, based on CentOS 7 Linux

# Docker Informations

* This image expose the following port

| Port | Usage |
|:----:|:-----:|
|  80/tcp  | HTTP Web application |

* This image takes theses environnements variables as parameters

|  Environment |       Type       | Default |                        Usage                        |
|:------------:|:----------------:|:-------:|:---------------------------------------------------:|
|    DB_HOST   |      String      | mariadb |                Set the database host                |
|    DB_PORT   |        Int       |   3306  |                Set the database port                |
|  DB_DATABASE |      String      |   glpi  |                Set the database name                |
|    DB_USER   |      String      |   glpi  |                Set the database user                |
|  DB_PASSWORD |      String      |   glpi  |              Set the database password              |
| IS_INSTALLED | Boolean<br>(0/1) |    0    | Set to 1 if it's not the first installation of glpi |

* The following volume is exposed by this image

|         Volume        |          Usage          |
|:---------------------:|:-----------------------:|
|  /var/www/glpi/files  |  The files path of GLPI |
| /var/www/glpi/plugins | The plugin path of GLPI |
| /var/www/glpi/marketplace | The marketplace path of GLPI |
| /var/www/glp/config   | The config path of GLPI |


# Usage

## Docker-compose Specific configuration examples

```yml
version: "3.2"

services:
#Mysql Container
  mysql:
    image: mariadb:10.4
    container_name: mysql
    hostname: mysql
    environment:
      - MYSQL_ROOT_PASSWORD=glpi
      - MYSQL_DATABASE=glpi
      - MYSQL_USER=glpi
      - MYSQL_PASSWORD=glpi
      - TZ=Etc/GMT+3
    volumes:
    - /path/to/data:/var/lib/mysql

#GLPI Container
  glpi:
    image: kaneymhf/docker-glpi
    container_name : glpi
    hostname: glpi
    ports:
      - "80:80"
    environment:
      - TZ=Etc/GMT+3
      - DB_HOST=mysql
      - DB_PORT=3306
      - DB_USER=glpi
      - DB_PASSWORD=glpi
      - DB_DATABASE=glpi
      - IS_INSTALLED=1
    volumes:
      - /path/to/files:/var/www/html/glpi/files
      - /path/to/plugins:/var/www/html/glpi/plugins
      - /path/to/marketplace:/var/www/html/glpi/marketplace
      - /path/to/config:/var/www/html/glpi/config
```
