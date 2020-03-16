FROM php:7.4-fpm-alpine

LABEL Maintainer="Jose Quintana <git.io/joseluisq>" \
  Description="Lightweight container with Nginx 1.17 & PHP-FPM 7.4 based on Alpine Linux."

# Install Nginx 1.17
# -> borrowed from official https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
ENV NGINX_VERSION 1.17.9
ENV NJS_VERSION   0.3.9
ENV PKG_RELEASE   1

RUN set -x \
# create nginx user/group first, to be consistent throughout docker variants
    && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
    && apkArch="$(cat /etc/apk/arch)" \
    && nginxPackages=" \
        nginx=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-xslt=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-geoip=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-image-filter=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-njs=${NGINX_VERSION}.${NJS_VERSION}-r${PKG_RELEASE} \
    " \
    && case "$apkArch" in \
        x86_64) \
# arches officially built by upstream
            set -x \
            && KEY_SHA512="e7fa8303923d9b95db37a77ad46c68fd4755ff935d0a534d26eba83de193c76166c68bfe7f65471bf8881004ef4aa6df3e34689c305662750c0172fca5d8552a *stdin" \
            && apk add --no-cache --virtual .cert-deps \
                openssl \
            && wget -O /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
            && if [ "$(openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout | openssl sha512 -r)" = "$KEY_SHA512" ]; then \
                echo "key verification succeeded!"; \
                mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/; \
            else \
                echo "key verification failed!"; \
                exit 1; \
            fi \
            && apk del .cert-deps \
            && apk add -X "https://nginx.org/packages/mainline/alpine/v$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)/main" --no-cache $nginxPackages \
            ;; \
        *) \
# we're on an architecture upstream doesn't officially build for
# let's build binaries from the published packaging sources
            set -x \
            && tempDir="$(mktemp -d)" \
            && chown nobody:nobody $tempDir \
            && apk add --no-cache --virtual .build-deps \
                gcc \
                libc-dev \
                make \
                openssl-dev \
                pcre-dev \
                zlib-dev \
                linux-headers \
                libxslt-dev \
                gd-dev \
                geoip-dev \
                perl-dev \
                libedit-dev \
                mercurial \
                bash \
                alpine-sdk \
                findutils \
            && su nobody -s /bin/sh -c " \
                export HOME=${tempDir} \
                && cd ${tempDir} \
                && hg clone https://hg.nginx.org/pkg-oss \
                && cd pkg-oss \
                && hg up ${NGINX_VERSION}-${PKG_RELEASE} \
                && cd alpine \
                && make all \
                && apk index -o ${tempDir}/packages/alpine/${apkArch}/APKINDEX.tar.gz ${tempDir}/packages/alpine/${apkArch}/*.apk \
                && abuild-sign -k ${tempDir}/.abuild/abuild-key.rsa ${tempDir}/packages/alpine/${apkArch}/APKINDEX.tar.gz \
                " \
            && cp ${tempDir}/.abuild/abuild-key.rsa.pub /etc/apk/keys/ \
            && apk del .build-deps \
            && apk add -X ${tempDir}/packages/alpine/ --no-cache $nginxPackages \
            ;; \
    esac \
# if we have leftovers from building, let's purge them (including extra, unnecessary build deps)
    && if [ -n "$tempDir" ]; then rm -rf "$tempDir"; fi \
    && if [ -n "/etc/apk/keys/abuild-key.rsa.pub" ]; then rm -f /etc/apk/keys/abuild-key.rsa.pub; fi \
    && if [ -n "/etc/apk/keys/nginx_signing.rsa.pub" ]; then rm -f /etc/apk/keys/nginx_signing.rsa.pub; fi \
# Bring in gettext so we can get `envsubst`, then throw
# the rest away. To do this, we need to install `gettext`
# then move `envsubst` out of the way so `gettext` can
# be deleted completely, then move `envsubst` back.
    && apk add --no-cache --virtual .gettext gettext \
    && mv /usr/bin/envsubst /tmp/ \
    \
    && runDeps="$( \
        scanelf --needed --nobanner /tmp/envsubst \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --no-cache $runDeps \
    && apk del .gettext \
    && mv /tmp/envsubst /usr/local/bin/ \
    && nginx -v \
#############################################
# Install additional packages
#############################################
    && apk add --no-cache \
# Install tzdata: bring in tzdata so users could set the timezones through the environment variables
        tzdata \
# Install CA Certificates
        ca-certificates \
# Install PHP Composer
        composer \
    && composer --version \
#############################################
# forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

#############################################
### Install and enable PHP extensions
#############################################

# Enable ffi if it exists
RUN set -eux \
	&& if [ -f /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini ]; then \
			echo "ffi.enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini; \
		fi

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

# development dependencies
    && apk add --no-cache --virtual .build-deps \
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

# workaround for rabbitmq linking issue
    && ln -s /usr/lib /usr/local/lib64

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

# Make the document root as a volume
VOLUME [ "/usr/share/nginx/html" ]

# Set Nginx root working directory
WORKDIR /usr/share/nginx/html

# Set Nginx root working directory permissions
RUN set -eux \
  && chown -R nginx:nginx /usr/share/nginx/html/ \
  && chmod -R g+s /usr/share/nginx/html/

# Copy Nginx root configuration files
COPY nginx/conf.d/. /etc/nginx/conf.d/
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Copy services entrypoint script
COPY scripts/entrypoint.sh /entrypoint.sh

# Copy PHP-FPM configuration files
COPY php7/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY php7/php.ini /usr/local/etc/php/conf.d/default-php.ini
COPY public/. /usr/share/nginx/html/

EXPOSE 80
EXPOSE 9000

STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
