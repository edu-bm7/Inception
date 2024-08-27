FROM debian:bullseye

# Set DEBIAN_FRONTEND to noninteractive to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    openssl \
    mariadb-client \
    imagemagick \
    php \
    php-json \
    php-fpm \
    php-mysqli \
    php-mbstring \
    php-curl \
    php-dom \
    php-exif \
    php-igbinary \
    php-intl \
    php-imagick \
    php-xml \
    php-zip \
    libxml2 \
    libcurl4 \
    libjpeg62-turbo \
    libpng-dev \
    libfreetype6-dev \
    libmagickwand-dev \
    libicu-dev \
    libzip-dev \
    && apt-get clean

RUN mkdir -p /run/php

COPY ./tools/entrypoint.sh /usr/local/bin/

COPY ./tools/wait_for_mariadb.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/wait_for_mariadb.sh

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/

# Set the working directory to /var/www/html, which is WordPress' default
WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT [ "/bin/bash", "/usr/local/bin/entrypoint.sh" ]