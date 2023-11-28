#!/bin/sh

set -e

CWD=/var/data/php-fpm

# 1. PHP-FPM default settings (php-fpm.conf)
XERROR_LOG=/proc/self/fd/2
XLOG_LEVEL=error

if [[ -z "$PHP_FPM_ERROR_LOG" ]]; then export PHP_FPM_ERROR_LOG=$XERROR_LOG; fi
if [[ -z "$PHP_FPM_LOG_LEVEL" ]]; then export PHP_FPM_LOG_LEVEL=$XLOG_LEVEL; fi

envsubst < "$CWD/php-fpm.tmpl.conf" > "/usr/local/etc/php-fpm.conf"

# 2. PHP-FPM WWW Pool (www.conf)
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

envsubst < "$CWD/www.tmpl.conf" > "/usr/local/etc/php-fpm.d/www.conf"

# 3. PHP default settings (default-php.ini)
# 3.1 [PHP]
XMEMORY_LIMIT=512M
XEXPOSE_PHP=On
# 3.2 [Session]
XGC_MAXLIFETIME=1440

if [[ -z "$PHP_MEMORY_LIMIT" ]];
    then export PHP_MEMORY_LIMIT=$XMEMORY_LIMIT; fi
if [[ -z "$PHP_EXPOSE_PHP" ]];
    then export PHP_EXPOSE_PHP=$XEXPOSE_PHP; fi
if [[ -z "$PHP_SESSION_GC_MAXLIFETIME" ]];
    then export PHP_SESSION_GC_MAXLIFETIME=$XGC_MAXLIFETIME; fi

envsubst < "$CWD/default-php.tmpl.ini" > "${PHP_INI_DIR}/conf.d/default-php.ini"
