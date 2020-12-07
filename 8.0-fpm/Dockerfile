FROM php:8.0.0-fpm-alpine

LABEL Maintainer="Jose Quintana <git.io/joseluisq>" \
    Description="PHP-FPM v8.0 with essential extensions on top of Alpine Linux."

# Install dependencies
RUN set -eux \
    && apk add --no-cache \
        ca-certificates \
        # composer \
        freetds \
        freetype \
        gettext \
        gmp \
        icu-libs \
        # imagemagick \
        libffi \
        libgmpxx \
        libintl \
        libjpeg-turbo \
        libmcrypt \
        libpng \
        libpq \
        # libssh2 \
        libtool \
        libxpm \
        libxslt \
        libzip \
        make \
        # rabbitmq-c \
        tidyhtml \
        tzdata \
        vips \
        yaml

#############################################
### Install and enable PHP extensions
#############################################

# Development dependencies
RUN set -eux \
    && apk add --no-cache --virtual .build-deps \
        autoconf \
        cmake \
        freetds-dev \
        freetype-dev \
        gcc \
        gettext-dev \
        git \
        gmp-dev \
        icu-dev \
        # imagemagick-dev \
        libc-dev \
        libjpeg-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libressl-dev \
        # libssh2-dev \
        libwebp-dev \
        libxml2-dev \
        libxpm-dev \
        libxslt-dev \
        libzip-dev \
        # linux-headers \
        openssl-dev \
        pcre-dev \
        pkgconf \
        postgresql-dev \
        # rabbitmq-c-dev \
        tidyhtml-dev \
        vips-dev \
        yaml-dev \
        zlib-dev \
\
    # Workaround for rabbitmq linking issue
    && ln -s /usr/lib /usr/local/lib64 \
    # Enable ffi if it exists
    && set -eux \
    && if [ -f /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini ]; then \
        echo "ffi.enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini; \
    fi \
\
################################
# Install PHP extensions
################################
\
# Install gd
    && ln -s /usr/lib/x86_64-linux-gnu/libXpm.* /usr/lib/ \
    && docker-php-ext-configure gd \
        --enable-gd \
        --with-webp \
        --with-jpeg \
        --with-xpm \
        --with-freetype \
        --enable-gd-jis-conv \
    && docker-php-ext-install gd \
    && true \
\
# # Install amqp
#     && echo "/usr" | pecl install amqp \
#     && docker-php-ext-enable amqp \
#     && true \
\
# Install gettext
    && docker-php-ext-install gettext \
    && true \
\
    # Install gmp
    && docker-php-ext-install gmp \
    && true \
\
# Install bcmath
    && docker-php-ext-install bcmath \
    && true \
\
# Install exif
    && docker-php-ext-install exif \
    && true \
\
# # Install imagick
#     && pecl install imagick \
#     && docker-php-ext-enable imagick \
#     && true \ 
\
# Install intl
    && docker-php-ext-install intl \
    && true \
\
# Install mcrypt
    && pecl install mcrypt \
    && docker-php-ext-enable mcrypt \
    && true \
\
# # Install xmlrpc
#     && docker-php-ext-configure xmlrpc --with-iconv-dir=/usr \
#     && docker-php-ext-install xmlrpc \
#     && true \
\
# Install memcache
    && pecl install memcache \
    && docker-php-ext-enable memcache \
    && true \
\
# Install mysqli
    && docker-php-ext-install mysqli \
    && true \
\
# Install oauth
    && pecl install oauth \
    && docker-php-ext-enable oauth \
    && true \
\
# Install pdo_mysql
    && docker-php-ext-configure pdo_mysql --with-zlib-dir=/usr \
    && docker-php-ext-install pdo_mysql \
    && true \
\
# Install pdo_dblib
    && docker-php-ext-install pdo_dblib \
    && true \
\
# Install pcntl
    && docker-php-ext-install pcntl \
    && true \
\
# Install pdo_pgsql
    && docker-php-ext-install pdo_pgsql \
    && true \
\
# Install pgsql
    && docker-php-ext-install pgsql \
    && true \
\
# Install psr
    && pecl install psr \
    && docker-php-ext-enable psr \
    && true \
\
# Install soap
    && docker-php-ext-install soap \
    && true \
\
# # Install ssh2
#     && pecl install ssh2-1.2 \
#     && docker-php-ext-enable ssh2 \
#     && true \
\
# Install tidy
    && docker-php-ext-install tidy \
    && true \
\
# Install xsl
    && docker-php-ext-install xsl \
    && true \
\
# Install yaml
    && pecl install yaml \
    && docker-php-ext-enable yaml \
    && true \
\
# Install vips
    && pecl install vips \
    && docker-php-ext-enable vips \
    && true \
\
# Install zip
    && docker-php-ext-configure zip --with-zip \
    && docker-php-ext-install zip \
    && true \
\
    # Clean up build packages
    && apk del .build-deps

# Install Composer
RUN set -eux \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --filename=composer --install-dir=/usr/local/bin \
    && php -r "unlink('composer-setup.php');" \
    && composer --version \
    && true

RUN set -eux \
    # Fix php.ini settings for enabled extensions
    && chmod +x "$(php -r 'echo ini_get("extension_dir");')"/* \
    # Shrink binaries
    && (find /usr/local/bin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
    && (find /usr/local/lib -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
    && (find /usr/local/sbin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true)

# Copy PHP-FPM configuration files
COPY 8.0-fpm/php-fpm.tmpl.conf /var/data/php-fpm/php-fpm.tmpl.conf
COPY 8.0-fpm/www.tmpl.conf /var/data/php-fpm/www.tmpl.conf
COPY 8.0-fpm/php.tmpl.ini /var/data/php-fpm/default-php.tmpl.ini

RUN set -eux \
    # PHP-FPM templates directory
    && mkdir -p /var/data/php-fpm \
    # Remove few PHP-FPM default config files
    && rm -rf /usr/local/etc/php-fpm.d/zz-docker.conf \
    && rm -rf /usr/local/etc/php-fpm.d/docker.conf \
    \
    # Perform PHP-FPM testing
    && echo "date.timezone=UTC" > /usr/local/etc/php/php.ini \
    && php -v | grep -oE 'PHP\s[.0-9]+' | grep -oE '[.0-9]+' | grep '^8.0' \
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

# Copy util scripts
COPY 8.0-fpm/envsubst.sh /envsubst.sh
COPY 8.0-fpm/entrypoint.sh /entrypoint.sh

STOPSIGNAL SIGQUIT

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000
CMD ["php-fpm"]


# Metadata
LABEL org.opencontainers.image.vendor="Jose Quintana" \
    org.opencontainers.image.url="https://github.com/joseluisq/alpine-php-fpm" \
    org.opencontainers.image.title="PHP-FPM v8.0 Alpine" \
    org.opencontainers.image.description="PHP-FPM v8.0 with essential extensions on top of Alpine Linux." \
    org.opencontainers.image.version="$PHP_VERSION" \
    org.opencontainers.image.documentation="https://github.com/joseluisq/alpine-php-fpm"
