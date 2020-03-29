FROM php:7.4-fpm-alpine

LABEL Maintainer="Jose Quintana <git.io/joseluisq>" \
  Description="PHP-FPM v7.4 with essential extensions on top of Alpine Linux."

ARG PHP_VERSION=${PHP_VERSION}

# Install dependencies
RUN apk add --no-cache \
        make \
        freetype \
        libpng \
        libintl \
        libtool \
        freetds \
        libjpeg-turbo \
        gmp \
        libgmpxx \
        libffi \
        icu-libs \
        libxpm \
        rabbitmq-c \
        gettext \
        imagemagick \
        libmcrypt \
        libpq \
        libssh2 \
        tidyhtml \
        yaml \
        libzip \
        vips \
        tzdata \
        ca-certificates \
        composer \
		libxslt

#############################################
### Install and enable PHP extensions
#############################################

# Development dependencies
RUN apk add --no-cache --virtual .build-deps \
        gcc \
        pkgconf \
        autoconf \
        git \
        cmake \
        linux-headers \
        pcre-dev \
        libc-dev \
        openssl-dev \
        zlib-dev \
        libxslt-dev \
        freetype-dev \
        libpng-dev \
        libwebp-dev \
        rabbitmq-c-dev \
        libxpm-dev \
        libxml2-dev \
        libressl-dev \
        postgresql-dev \
        imagemagick-dev \
        freetds-dev \
        gmp-dev \
        libzip-dev \
        libjpeg-turbo-dev \
        libmcrypt-dev \
        gettext-dev \
        libssh2-dev \
        tidyhtml-dev \
        yaml-dev \
        icu-dev \
        vips-dev

# Workaround for rabbitmq linking issue
RUN ln -s /usr/lib /usr/local/lib64

# Enable ffi if it exists
RUN set -eux \
	&& if [ -f /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini ]; then \
			echo "ffi.enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini; \
		fi

# Install gd
RUN set -eux \
    && ln -s /usr/lib/x86_64-linux-gnu/libXpm.* /usr/lib/ \
	&& docker-php-ext-configure gd \
        --enable-gd \
        --with-webp \
        --with-jpeg \
        --with-xpm \
        --with-freetype \
        --enable-gd-jis-conv \
	&& docker-php-ext-install gd \
	&& true

# Install amqp
RUN set -eux \
	&& echo "/usr" | pecl install amqp \
	&& docker-php-ext-enable amqp \
	&& true

# Install gettext
RUN set -eux \
	&& docker-php-ext-install gettext \
	&& true

# Install gmp
RUN set -eux \
	&& docker-php-ext-install gmp \
	&& true

# Install bcmath
RUN set -eux \
	&& docker-php-ext-install bcmath \
	&& true

# Install exif
RUN set -eux \
	&& docker-php-ext-install exif \
	&& true

# Install imagick
RUN set -eux \
	&& pecl install imagick \
	&& docker-php-ext-enable imagick \
	&& true

# Install intl
RUN set -eux \
	&& docker-php-ext-install intl \
	&& true

# Install mcrypt
RUN set -eux \
	&& pecl install mcrypt \
	&& docker-php-ext-enable mcrypt \
	&& true

# Install xmlrpc
RUN set -eux \
	&& docker-php-ext-configure xmlrpc --with-iconv-dir=/usr \
	&& docker-php-ext-install xmlrpc \
	&& true

# Install memcache
RUN set -eux \
	&& pecl install memcache \
	&& docker-php-ext-enable memcache \
	&& true

# Install mysqli
RUN set -eux \
	&& docker-php-ext-install mysqli \
	&& true

# Install oauth
RUN set -eux \
	&& pecl install oauth \
	&& docker-php-ext-enable oauth \
	&& true

# Install pdo_mysql
RUN set -eux \
	&& docker-php-ext-configure pdo_mysql --with-zlib-dir=/usr \
	&& docker-php-ext-install pdo_mysql \
	&& true

# Install pdo_dblib
RUN set -eux \
	&& docker-php-ext-install pdo_dblib \
	&& true

# Install pcntl
RUN set -eux \
	&& docker-php-ext-install pcntl \
	&& true

# Install pdo_pgsql
RUN set -eux \
	&& docker-php-ext-install pdo_pgsql \
	&& true

# Install pgsql
RUN set -eux \
	&& docker-php-ext-install pgsql \
	&& true

# Install psr
RUN set -eux \
	&& pecl install psr \
	&& docker-php-ext-enable psr \
	&& true

# Install soap
RUN set -eux \
	&& docker-php-ext-install soap \
	&& true

# Install ssh2
RUN set -eux \
	&& pecl install ssh2-1.2 \
	&& docker-php-ext-enable ssh2 \
	&& true

# Install tidy
RUN set -eux \
	&& docker-php-ext-install tidy \
	&& true

# Install xsl
RUN set -eux \
	&& docker-php-ext-install xsl \
	&& true

# Install yaml
RUN set -eux \
	&& pecl install yaml \
	&& docker-php-ext-enable yaml \
	&& true

# Install vips
RUN set -eux \
	&& pecl install vips \
	&& docker-php-ext-enable vips \
	&& true

# Install zip
RUN set -eux \
	&& docker-php-ext-configure zip --with-zip \
	&& docker-php-ext-install zip \
	&& true

# Fix php.ini settings for enabled extensions
RUN set -eux \
	&& chmod +x "$(php -r 'echo ini_get("extension_dir");')"/*

# Shrink everything down
RUN set -eux \
	&& (find /usr/local/bin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
	&& (find /usr/local/lib -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
	&& (find /usr/local/sbin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true)

# Clean up build packages
RUN set -eux \
    && docker-php-source delete \
    && apk del .build-deps

# Perform PHP-FPM testing
RUN set -eux \
	&& echo "date.timezone=UTC" > /usr/local/etc/php/php.ini \
	&& php -v | grep -oE 'PHP\s[.0-9]+' | grep -oE '[.0-9]+' | grep '^7.4' \
	&& /usr/local/sbin/php-fpm --test \
	\
	&& PHP_ERROR="$( php -v 2>&1 1>/dev/null )" \
	&& if [ -n "${PHP_ERROR}" ]; then echo "${PHP_ERROR}"; false; fi \
	&& PHP_ERROR="$( php -i 2>&1 1>/dev/null )" \
	&& if [ -n "${PHP_ERROR}" ]; then echo "${PHP_ERROR}"; false; fi \
	\
	&& PHP_FPM_ERROR="$( php-fpm -v 2>&1 1>/dev/null )" \
	&& if [ -n "${PHP_FPM_ERROR}" ]; then echo "${PHP_FPM_ERROR}"; false; fi \
	&& PHP_FPM_ERROR="$( php-fpm -i 2>&1 1>/dev/null )" \
	&& if [ -n "${PHP_FPM_ERROR}" ]; then echo "${PHP_FPM_ERROR}"; false; fi \
	&& rm -f /usr/local/etc/php/php.ini

# Copy PHP-FPM configuration files
COPY php-fpm/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY php-fpm/php.ini /usr/local/etc/php/conf.d/default-php.ini

# Copy services entrypoint script
COPY php-fpm/entrypoint.sh /entrypoint.sh

STOPSIGNAL SIGQUIT

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000
CMD ["php-fpm"]


# Metadata
LABEL org.opencontainers.image.vendor="Jose Quintana" \
    org.opencontainers.image.url="https://github.com/joseluisq/alpine-nginx-php-fpm" \
    org.opencontainers.image.title="PHP-FPM v7.4 Alpine" \
    org.opencontainers.image.description="PHP-FPM v7.4 with essential extensions on top of Alpine Linux." \
    org.opencontainers.image.version="$PHP_VERSION" \
    org.opencontainers.image.documentation="https://github.com/joseluisq/alpine-nginx-php-fpm"
