ARG ZABBIX_WEB_NGINX_MYSQL_IMAGE="zabbix/zabbix-web-nginx-mysql"
ARG ZABBIX_UBUNTU_IMAGE_TAG="6.0.31-ubuntu"
ARG ZABBIX_IMAGE_TAG_POSTFIX=""
FROM ${ZABBIX_WEB_NGINX_MYSQL_IMAGE}:${ZABBIX_UBUNTU_IMAGE_TAG}${ZABBIX_IMAGE_TAG_POSTFIX}

# Install required packages
USER root
# Install XDebug
RUN apt-get update && apt-get install -y php8.1-xdebug

# Configure XDebug 3
RUN echo "zend_extension=xdebug.so" >> /etc/php/8.1/mods-available/xdebug.ini \
    && echo "xdebug.mode=develop,debug" >> /etc/php/8.1/mods-available/xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /etc/php/8.1/mods-available/xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /etc/php/8.1/mods-available/xdebug.ini \
    && echo "xdebug.client_port=9004" >> /etc/php/8.1/mods-available/xdebug.ini

RUN service php8.1-fpm restart