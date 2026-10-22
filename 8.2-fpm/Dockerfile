# PIE (PHP Installer for Extensions) - https://github.com/php/pie
ARG PIE_VERSION="1.5.2"

# The PIE image only holds a PHAR and isn't published for 32-bit targets, so use the build platform
FROM --platform=$BUILDPLATFORM ghcr.io/php/pie:${PIE_VERSION}-bin AS pie

FROM php:8.2.35-fpm-alpine3.24

LABEL Maintainer="Jose Quintana <joseluisq.net>" \
    Description="PHP-FPM v8.2 with essential extensions on top of Alpine Linux."

# Composer - https://getcomposer.org/download/
ARG COMPOSER_VERSION="2.10.3"
ARG COMPOSER_SUM="7a2d379d5b8ffdaa028580ef26494c36d2feef4b178d3dd1473a4dbc5e17c8d6"

# Swoole - https://github.com/swoole/swoole-src
ARG SWOOLE_VERSION="6.2.3"

# Phalcon - https://github.com/phalcon/cphalcon
ARG PHALCON_VERSION="5.23.0"

# PECL extensions without a PIE package - https://pecl.php.net
ARG MEMCACHE_VERSION="8.2"
ARG OAUTH_VERSION="2.0.10"
ARG PSR_VERSION="1.2.0"
ARG SSH2_VERSION="1.3.1"
# Last sqlsrv/pdo_sqlsrv releases supporting PHP 8.2 (the Packagist ones require PHP 8.3+)
ARG SQLSRV_VERSION="5.12.0"
ARG VIPS_VERSION="1.0.13"

# Install dependencies
RUN set -eux \
    && apk add --no-cache \
        c-client \
        ca-certificates \
        freetds \
        freetype \
        gettext \
        gmp \
        icu-libs \
        imagemagick \
        imap \
        libffi \
        libgmpxx \
        libintl \
        libjpeg-turbo \
        libpng \
        libpq \
        librdkafka \
        libssh2 \
        libstdc++ \
        libtool \
        libxpm \
        libxslt \
        libzip \
        lz4-libs \
        make \
        rabbitmq-c \
        tidyhtml \
        tzdata \
        unixodbc \
        vips \
        yaml \
        zstd-libs \
    && true

#############################################
### Install and enable PHP extensions
#############################################

# Development dependencies
RUN --mount=type=bind,from=pie,source=/pie,target=/usr/local/bin/pie \
    set -eux \
    && apk add --no-cache --virtual .build-deps \
        autoconf \
        bzip2-dev \
        cmake \
        curl-dev \
        freetds-dev \
        freetype-dev \
        g++ \
        gcc \
        gettext-dev \
        git \
        gmp-dev \
        icu-dev \
        imagemagick-dev \
        imap-dev \
        krb5-dev \
        libc-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        librdkafka-dev \
        libssh2-dev \
        libwebp-dev \
        libxml2-dev \
        libxpm-dev \
        libxslt-dev \
        libzip-dev \
        lz4-dev \
        openssl-dev \
        pcre-dev \
        pkgconf \
        postgresql-dev \
        rabbitmq-c-dev \
        tidyhtml-dev \
        unixodbc-dev \
        unzip \
        vips-dev \
        yaml-dev \
        zlib-dev \
        zstd-dev \
\
# Workaround for rabbitmq linking issue
    && ln -s /usr/lib /usr/local/lib64 \
\
# Enable ffi if it exists
    && set -eux \
    && if [ -f /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini ]; then \
        echo "ffi.enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini; \
    fi \
\
# PHP sources, also used to build the PECL extensions that have no PIE package
    && docker-php-source extract \
\
################################
# Install PHP extensions
################################
\
# Install gd
    && ln -s /usr/lib/$(apk --print-arch)-linux-gnu/libXpm.* /usr/lib/ \
    && docker-php-ext-configure gd \
        --enable-gd \
        --with-webp \
        --with-jpeg \
        --with-xpm \
        --with-freetype \
        --enable-gd-jis-conv \
    && docker-php-ext-install -j$(nproc) gd \
    && true \
\
# Install amqp
    && pie install php-amqp/php-amqp \
    && true \
\
# Install apcu
    && pie install apcu/apcu \
    && true \
\
# Install gettext
    && docker-php-ext-install -j$(nproc) gettext \
    && true \
\
# Install gmp
    && docker-php-ext-install -j$(nproc) gmp \
    && true \
\
# Install bcmath
    && docker-php-ext-install -j$(nproc) bcmath \
    && true \
\
# Install bz2
    && docker-php-ext-install -j$(nproc) bz2 \
    && true \
\
# Install exif
    && docker-php-ext-install -j$(nproc) exif \
    && true \
\
# Install imap
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl --with-imap \
    && docker-php-ext-install -j$(nproc) imap \
    && true \
\
# Install imagick
    && pie install imagick/imagick \
    && true \
\
# Install igbinary
# igbinary only has a release candidate on Packagist (also what PECL ships as stable)
    && pie install "igbinary/igbinary:^3.2.17@RC" \
    && true \
\
# Install intl
    && docker-php-ext-install -j$(nproc) intl \
    && true \
\
# Install lz4
    && git clone https://github.com/kjdev/php-ext-lz4 /opt/lz4 \
    && cd /opt/lz4 \
    && git checkout $(git tag | grep -E '^[.0-9]+$' | sort -V | tail -1) \
    && phpize \
    && ./configure --enable-lz4 --with-lz4-includedir=/usr \
    && make -j$(nproc) \
    && make install \
    && docker-php-ext-enable lz4 \
    && true \
\
# Install memcache (no PIE package)
    && curl -fsSL --retry 5 --retry-all-errors -o /tmp/memcache.tgz https://pecl.php.net/get/memcache-${MEMCACHE_VERSION}.tgz \
    && mkdir -p /usr/src/php/ext/memcache \
    && tar xzf /tmp/memcache.tgz --strip-components=1 -C /usr/src/php/ext/memcache \
    && docker-php-ext-install -j$(nproc) memcache \
    && true \
\
# Install mongodb
    && pie install mongodb/mongodb-extension \
    && true \
\
# Install msgpack
    && pie install msgpack/msgpack-php \
    && true \
\
# Install mysqli
    && docker-php-ext-install -j$(nproc) mysqli \
    && true \
\
# Install oauth (no PIE package)
    && curl -fsSL --retry 5 --retry-all-errors -o /tmp/oauth.tgz https://pecl.php.net/get/oauth-${OAUTH_VERSION}.tgz \
    && mkdir -p /usr/src/php/ext/oauth \
    && tar xzf /tmp/oauth.tgz --strip-components=1 -C /usr/src/php/ext/oauth \
    && docker-php-ext-install -j$(nproc) oauth \
    && true \
\
# Install opcache
    && docker-php-ext-install -j$(nproc) opcache \
    && true \
\
# Install pdo_mysql
    && docker-php-ext-configure pdo_mysql --with-zlib-dir=/usr \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && true \
\
# Install pdo_dblib
    && docker-php-ext-install -j$(nproc) pdo_dblib \
    && true \
\
# Install pcntl
    && docker-php-ext-install -j$(nproc) pcntl \
    && true \
\
# Install phalcon
    && git clone --depth=1 --branch=v${PHALCON_VERSION} https://github.com/phalcon/cphalcon.git /opt/phalcon \
    && cd /opt/phalcon/build \
# Fix 32-bit builds (GCC >= 14 errors on incompatible pointer types)
    && sed -i 's/unsigned long \*position/zend_ulong *position/' phalcon/phalcon.zep.c \
# Keep cc1 within the 32-bit address space: GCC sizes its GC thresholds from host RAM
    && PHALCON_CFLAGS="" \
    && if [ "$(getconf LONG_BIT)" = "32" ]; then \
        PHALCON_CFLAGS="-O2 -fomit-frame-pointer --param ggc-min-expand=20 --param ggc-min-heapsize=32768"; \
    fi \
    && CFLAGS="$PHALCON_CFLAGS" sh ./install \
# The install script ignores build errors, so make sure the module exists
    && test -f "$(php-config --extension-dir)/phalcon.so" \
    && docker-php-ext-enable phalcon \
    && true \
\
# Install pdo_pgsql
    && docker-php-ext-install -j$(nproc) pdo_pgsql \
    && true \
\
# Install pgsql
    && docker-php-ext-install -j$(nproc) pgsql \
    && true \
\
# ONLY 64-bit targets
    && if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "aarch64" ]; then \
    # Install sqlsrv (no PIE package for PHP 8.2)
        curl -fsSL --retry 5 --retry-all-errors -o /tmp/sqlsrv.tgz https://pecl.php.net/get/sqlsrv-${SQLSRV_VERSION}.tgz; \
        mkdir -p /usr/src/php/ext/sqlsrv; \
        tar xzf /tmp/sqlsrv.tgz --strip-components=1 -C /usr/src/php/ext/sqlsrv; \
        docker-php-ext-install -j$(nproc) sqlsrv; \
        true; \
    # Install pdo_sqlsrv (no PIE package for PHP 8.2)
        curl -fsSL --retry 5 --retry-all-errors -o /tmp/pdo_sqlsrv.tgz https://pecl.php.net/get/pdo_sqlsrv-${SQLSRV_VERSION}.tgz; \
        mkdir -p /usr/src/php/ext/pdo_sqlsrv; \
        tar xzf /tmp/pdo_sqlsrv.tgz --strip-components=1 -C /usr/src/php/ext/pdo_sqlsrv; \
        docker-php-ext-install -j$(nproc) pdo_sqlsrv; \
        true; \
    fi \
\
# Install redis
    && pie install phpredis/phpredis \
        --enable-redis-igbinary \
        --enable-redis-zstd \
        --enable-redis-msgpack \
        --enable-redis-lz4 \
        --with-liblz4=yes \
    && true \
\
# Install rdkafka
    && pie install rdkafka/rdkafka \
    && true \
\
# Install soap
    && docker-php-ext-install -j$(nproc) soap \
    && true \
\
# Install ssh2 (no PIE package)
    && curl -fsSL --retry 5 --retry-all-errors -o /tmp/ssh2.tgz https://pecl.php.net/get/ssh2-${SSH2_VERSION}.tgz \
    && mkdir -p /usr/src/php/ext/ssh2 \
    && tar xzf /tmp/ssh2.tgz --strip-components=1 -C /usr/src/php/ext/ssh2 \
    && docker-php-ext-install -j$(nproc) ssh2 \
    && true \
\
# Install sockets, sysvmsg, sysvsem, sysvshm (also needed by swoole)
    && CFLAGS="${CFLAGS:=} -D_GNU_SOURCE" docker-php-ext-install -j$(nproc) \
        sockets \
        sysvmsg \
        sysvsem \
        sysvshm \
    && docker-php-source extract \
    && true \
\
# Install swoole (64-bit targets only)
# https://github.com/swoole/swoole-src/issues/5158
    && if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "aarch64" ]; then \
        mkdir /usr/src/php/ext/swoole; \
        curl -Lo swoole.tar.gz https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz; \
        tar xfz swoole.tar.gz --strip-components=1 -C /usr/src/php/ext/swoole; \
        docker-php-ext-configure swoole \
                --enable-mysqlnd \
                --enable-sockets \
                --enable-openssl \
                --enable-swoole-curl; \
        docker-php-ext-install -j$(nproc) swoole; \
        rm -rf swoole.tar.gz $HOME/.composer/*-old.phar; \
        docker-php-ext-enable swoole; \
        true; \
    fi \
\
# Install tidy
    && docker-php-ext-install -j$(nproc) tidy \
    && true \
\
# Install uuid
    && pie install pecl/uuid \
    && true \
\
# Install xsl
    && docker-php-ext-install -j$(nproc) xsl \
    && true \
\
# Install xdebug
    && pie install xdebug/xdebug \
    && true \
\
# Install yaml
    && pie install pecl/yaml \
    && true \
\
# Install vips (no PIE package)
    && curl -fsSL --retry 5 --retry-all-errors -o /tmp/vips.tgz https://pecl.php.net/get/vips-${VIPS_VERSION}.tgz \
    && mkdir -p /usr/src/php/ext/vips \
    && tar xzf /tmp/vips.tgz --strip-components=1 -C /usr/src/php/ext/vips \
    && docker-php-ext-install -j$(nproc) vips \
    && true \
\
# Install zip
    && docker-php-ext-configure zip --with-zip \
    && docker-php-ext-install -j$(nproc) zip \
    && true \
\
# Install zstd
    && pie install kjdev/zstd \
    && true \
\
# Install psr (no PIE package)
# Keep it after every `pie install`: PIE refuses to run while ext-psr is loaded
    && curl -fsSL --retry 5 --retry-all-errors -o /tmp/psr.tgz https://pecl.php.net/get/psr-${PSR_VERSION}.tgz \
    && mkdir -p /usr/src/php/ext/psr \
    && tar xzf /tmp/psr.tgz --strip-components=1 -C /usr/src/php/ext/psr \
    && docker-php-ext-install -j$(nproc) psr \
    && true \
\
# Clean up build packages
    && docker-php-source delete \
    && apk del .build-deps \
    && rm -rf /tmp/* /root/.pie /root/.composer/cache \
    && true

RUN set -eux \
# Fix php.ini settings for enabled extensions
    && chmod +x "$(php -r 'echo ini_get("extension_dir");')"/* \
# Shrink binaries
    && (find /usr/local/bin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
    && (find /usr/local/lib -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
    && (find /usr/local/sbin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
    && true

# Install Composer
RUN set -eux \
    && curl -LO "https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar" \
    && echo "${COMPOSER_SUM}  composer.phar" | sha256sum -c - \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && composer --version \
    && true

# Copy PHP-FPM configuration files
COPY 8.2-fpm/php-fpm.tmpl.conf /var/data/php-fpm/php-fpm.tmpl.conf
COPY 8.2-fpm/www.tmpl.conf /var/data/php-fpm/www.tmpl.conf
COPY 8.2-fpm/php.tmpl.ini /var/data/php-fpm/default-php.tmpl.ini

RUN set -eux \
# PHP-FPM templates directory
    && mkdir -p /var/data/php-fpm \
# Remove few PHP-FPM default config files
    && rm -rf /usr/local/etc/php-fpm.d/zz-docker.conf \
    && rm -rf /usr/local/etc/php-fpm.d/docker.conf \
# Newer base images moved the default `listen` from www.conf into docker.conf, so restore it
    && sed -i "s/^;listen = 127.0.0.1:9000$/listen = 127.0.0.1:9000/" /usr/local/etc/php-fpm.d/www.conf \
\
# Perform PHP-FPM testing
    && echo "Performing PHP-FPM tests..." \
    && echo "date.timezone=UTC" > /usr/local/etc/php/php.ini \
    && php -v | grep -oE 'PHP\s[.0-9]+' | grep -oE '[.0-9]+' | grep '^8.2' \
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
    && rm -f /usr/local/etc/php/php.ini \
    && true

# Copy util scripts
COPY 8.2-fpm/envsubst.sh /envsubst.sh
COPY 8.2-fpm/entrypoint.sh /entrypoint.sh

STOPSIGNAL SIGQUIT

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000
CMD ["php-fpm"]


# Metadata
LABEL org.opencontainers.image.vendor="Jose Quintana" \
    org.opencontainers.image.url="https://github.com/joseluisq/alpine-php-fpm" \
    org.opencontainers.image.title="PHP-FPM v8.2 Alpine" \
    org.opencontainers.image.description="PHP-FPM v8.2 with essential extensions on top of Alpine Linux." \
    org.opencontainers.image.version="$PHP_VERSION" \
    org.opencontainers.image.documentation="https://github.com/joseluisq/alpine-php-fpm"
