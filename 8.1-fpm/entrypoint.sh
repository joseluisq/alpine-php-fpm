#!/bin/sh

set -e

# Check if incomming command contains flags.
if [ "${1#-}" != "$1" ]; then
    set -- php-fpm "$@"
fi

# Replace environment variables if `ENV_SUBSTITUTION_ENABLE=true`
if [[ -n "$ENV_SUBSTITUTION_ENABLE" ]] && [[ "$ENV_SUBSTITUTION_ENABLE" = "true" ]]; then
    /envsubst.sh
fi

exec "$@"
