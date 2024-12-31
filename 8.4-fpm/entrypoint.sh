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

# Disable PHP extensions on demand
extensions=${PHP_DISABLE_EXTENSIONS//[[:blank:]]/}
extensions=${extensions//,/ }
extensions_count=$(echo $extensions | grep -o " " | wc -l)

if [[ -n "$extensions" ]]; then extensions_count=$((extensions_count + 1)); fi

if [[ $extensions_count -gt 0 ]]; then
    echo "Disabling $extensions_count extension(s): $(echo $extensions)"

    ext_dir=$(php -r 'echo ini_get("extension_dir");')
    for ext in $extensions; do
        disabled=0

        ext_file="$ext_dir/$ext.so"
        if [[ -f "$ext_file" ]]; then
            mv -f $ext_file "$ext_file.disabled"
            disabled=1
        fi

        ext_file_ini=${PHP_INI_DIR}/conf.d/docker-php-ext-$ext.ini
        if [[ -f "$ext_file_ini" ]]; then
            mv -f $ext_file_ini "$ext_file_ini.disabled"
            disabled=1
        fi

        if [[ "$disabled" = 1 ]]; then
            echo "OK: '$ext' disabled"
        fi
    done

    echo "Verifying PHP extensions..."

    php -v
    php-fpm --test

    PHP_ERROR="$(php -v 2>&1 1>/dev/null)"

    if [ -n "${PHP_ERROR}" ]; then
        echo "${PHP_ERROR}"
        false
    fi

    PHP_ERROR="$(php -i 2>&1 1>/dev/null)"

    if [ -n "${PHP_ERROR}" ]; then
        echo "${PHP_ERROR}"
        false
    fi

    PHP_FPM_ERROR="$(php-fpm -v 2>&1 1>/dev/null)"

    if [ -n "${PHP_FPM_ERROR}" ]; then
        echo "${PHP_FPM_ERROR}"
        false
    fi

    PHP_FPM_ERROR="$(php-fpm -i 2>&1 1>/dev/null)"

    if [ -n "${PHP_FPM_ERROR}" ]; then
        echo "${PHP_FPM_ERROR}"
        false
    fi

    echo "Tests were successful!"
    echo
fi

exec "$@"
