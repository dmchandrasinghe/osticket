ARG OSTICKET_VERSION=v1.14.3

FROM php:7.4-apache

LABEL maintainer="Dinusha Chandrasinghe" \
      description="osTicket support stack based on PHP 7.4 and Apache"
ARG OSTICKET_VERSION
RUN echo "Building osTiup/install.phpcket support stack with version ${OSTICKET_VERSION}"


# Install required PHP extensions and utilities
RUN apt-get update && apt-get install -y \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libzip-dev \
    libmariadb-dev \
    libc-client-dev \
    libkrb5-dev \
    libicu-dev \
    dos2unix \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-configure intl \
    && docker-php-ext-install \
        gd \
        mysqli \
        imap \
        mbstring \
        xml \
        zip \
        curl \
        intl \
        opcache \
    && pecl install apcu \
    && docker-php-ext-enable \
        apcu \
        opcache \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP
RUN { \
    echo 'extension=apcu.so'; \
    echo 'date.timezone=UTC'; \
    echo 'upload_max_filesize=32M'; \
    echo 'post_max_size=32M'; \
} > /usr/local/etc/php/conf.d/custom.ini

# Configure OPcache
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Download and install osTicket
RUN curl -LJO https://github.com/osTicket/osTicket/releases/download/${OSTICKET_VERSION}/osTicket-${OSTICKET_VERSION}.zip \
    && unzip osTicket-${OSTICKET_VERSION}.zip
RUN rm osTicket-${OSTICKET_VERSION}.zip \
    && pwd \
    && ls \
    && mv upload/* /var/www/html/ \
    && chown -R www-data:www-data /var/www/html

# Copy and prepare config
RUN cp /var/www/html/include/ost-sampleconfig.php /var/www/html/include/ost-config.php \
    && chown www-data:www-data /var/www/html/include/ost-config.php \
    && chmod 0666 /var/www/html/include/ost-config.php

COPY ./env-write.sh /usr/local/bin/env-write.sh
RUN dos2unix /usr/local/bin/env-write.sh
RUN chmod +x /usr/local/bin/env-write.sh

EXPOSE 80

# Change CMD to use env-write.sh
CMD ["/usr/local/bin/env-write.sh"]
