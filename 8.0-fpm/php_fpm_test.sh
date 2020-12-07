#!/bin/sh

set -eu

echo "Testing PHP-FPM configurations and extensions..."
echo

php -v
echo

PHP_VERSION=$(php -v | grep -oE 'PHP\s[.0-9]+' | grep -oE '[.0-9]+' | grep '^8.0')

echo "Using PHP v$PHP_VERSION"
echo

php-fpm --test


echo "Verifying PHP extensions..."
echo

PHP_ERROR="$(php -v 2>&1 1>/dev/null)"

if [ -n "${PHP_ERROR}" ]; then
    echo "${PHP_ERROR}";
    false;
fi

PHP_ERROR="$(php -i 2>&1 1>/dev/null)"

if [ -n "${PHP_ERROR}" ]; then
    echo "${PHP_ERROR}";
    false;
fi

PHP_FPM_ERROR="$(php-fpm -v 2>&1 1>/dev/null)"

if [ -n "${PHP_FPM_ERROR}" ]; then
    echo "${PHP_FPM_ERROR}";
    false;
fi

PHP_FPM_ERROR="$(php-fpm -i 2>&1 1>/dev/null)"

if [ -n "${PHP_FPM_ERROR}" ]; then
    echo "${PHP_FPM_ERROR}";
    false;
fi

echo "Tests were successful!"
