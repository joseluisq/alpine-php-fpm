FROM nginx:1.17-alpine AS server

FROM joseluisq/php:7.4-fpm

LABEL Maintainer="Jose Quintana <git.io/joseluisq>" \
  Description="Lightweight Nginx 1.17 & PHP-FPM 7.4 based on Alpine Linux."

ENV NGINX_VERSION 1.17

ARG NGINX_VERSION=${NGINX_VERSION}

RUN set -eux \
    && apk add --no-cache \
        tzdata \
        ca-certificates

RUN set -eux \
    && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx

# Make the document root as a volume
VOLUME [ "/usr/share/nginx/html" ]

# Set Nginx root working directory
WORKDIR /usr/share/nginx/html

COPY --from=server /usr/sbin/nginx /usr/sbin/nginx
COPY --from=server /usr/local/bin/envsubst /usr/local/bin/
COPY --from=server /usr/bin/njs /usr/bin/
COPY --from=server /etc/nginx/. /etc/nginx/

RUN set -eux \
    && nginx -v \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && chown -R nginx:nginx /usr/share/nginx/html/ \
    && chmod -R g+s /usr/share/nginx/html/

# Copy Nginx root configuration files
COPY nginx/conf.d/. /etc/nginx/conf.d/
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Copy services entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Copy public example directory
COPY public/. /usr/share/nginx/html/

EXPOSE 80
EXPOSE 9000

STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]


# Metadata
LABEL org.opencontainers.image.vendor="Jose Quintana" \
    org.opencontainers.image.url="https://github.com/joseluisq/alpine-php-fpm/tree/master/php-fpm-nginx" \
    org.opencontainers.image.title="Nginx 1.17 & PHP-FPM 7.4 Alpine" \
    org.opencontainers.image.description="Lightweight Nginx 1.17 & PHP-FPM 7.4 based on Alpine Linux." \
    org.opencontainers.image.version="$NGINX_VERSION" \
    org.opencontainers.image.documentation="https://github.com/joseluisq/alpine-php-fpm/tree/master/php-fpm-nginx"
