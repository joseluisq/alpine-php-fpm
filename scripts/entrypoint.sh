#!/bin/sh

set -euo pipefail

# Start PHP-FPM and Nginx server by default
if [[ "$1" == "nginx" ]]; then
    php-fpm & exec "$@"
    exit
fi

# Check if incomming command contains Nginx flags.
if [[ "${1#-}" != "$1" ]]; then
    set -- nginx "$@"
fi

exec "$@"
