#build php-fpm
FROM php:8.1-cli-alpine3.15
ARG WITH_DEBUG=false
ENV SWOOLE_VERSION=4.8.10

##install dependencies
RUN apk --no-cache add\
        alpine-sdk \
    && apk add --no-cache --virtual .build-deps ${PHPIZE_DEPS} \
    && pecl install swoole \
#install php extensions
    && docker-php-ext-install \
        bcmath \
        pcntl \
    && docker-php-ext-enable swoole

COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer
COPY . /var/www
WORKDIR /var/www
RUN composer install
CMD ["php", "/var/www/bin/server"]
