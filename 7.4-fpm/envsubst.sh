#!/bin/sh

set -e

# 1. PHP-FPM default settings
XUSER=www-data
XGROUP=www-data
XLISTEN=9000
XLISTEN_OWNER=$XUSER
XLISTEN_GROUP=$XGROUP

if [[ -z "$PHP_FPM_LISTEN" ]]; then export PHP_FPM_LISTEN=$XLISTEN; fi
if [[ -z "$PHP_FPM_USER" ]]; then export PHP_FPM_USER=$XUSER; fi
if [[ -z "$PHP_FPM_GROUP" ]]; then export PHP_FPM_GROUP=$XGROUP; fi
if [[ -z "$PHP_FPM_LISTEN_OWNER" ]]; then export PHP_FPM_LISTEN_OWNER=$XLISTEN_OWNER; fi
if [[ -z "$PHP_FPM_LISTEN_GROUP" ]]; then export PHP_FPM_LISTEN_GROUP=$XLISTEN_GROUP; fi

CWD=/var/data/php-fpm

envsubst < "$CWD/php-fpm.tmpl.conf" > "/usr/local/etc/php-fpm.conf"
envsubst < "$CWD/www.tmpl.conf" > "/usr/local/etc/php-fpm.d/www.conf"

# 2. PHP default settings
XMEMORY_LIMIT=512M

if [[ -z "$PHP_MEMORY_LIMIT" ]]; then export PHP_MEMORY_LIMIT=$XMEMORY_LIMIT; fi

envsubst < "$CWD/default-php.tmpl.ini" > "/usr/local/etc/php/conf.d/default-php.ini"
