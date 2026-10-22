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
    ext_ini_dir=${PHP_INI_DIR}/conf.d

    # Extensions are disabled by renaming their files, which needs root
    if [ ! -w "$ext_dir" ] || [ ! -w "$ext_ini_dir" ]; then
        echo "ERROR: PHP_DISABLE_EXTENSIONS requires running the container as root (current user: $(id -un))" >&2
        exit 1
    fi

    for ext in $extensions; do
        disabled=0

        case "$ext" in
            *[!A-Za-z0-9_]*)
                echo "WARN: '$ext' is not a valid extension name, skipped"
                continue
                ;;
        esac

        ext_file="$ext_dir/$ext.so"
        if [[ -f "$ext_file" ]]; then
            mv -f "$ext_file" "$ext_file.disabled"
            disabled=1
        fi

        ext_file_ini=$ext_ini_dir/docker-php-ext-$ext.ini
        if [[ -f "$ext_file_ini" ]]; then
            mv -f "$ext_file_ini" "$ext_file_ini.disabled"
            disabled=1
        fi

        if [[ "$disabled" = 1 ]]; then
            echo "OK: '$ext' disabled"
        elif [[ -f "$ext_file.disabled" ]]; then
            # Container restarted with the same settings
            echo "OK: '$ext' already disabled"
        else
            echo "WARN: '$ext' is not an optional extension of this image (built-in or unknown), skipped"
        fi
    done

    echo "Verifying PHP extensions..."

    php -v
    php-fpm --test

    # Startup errors (e.g. an extension needing a disabled one) are displayed on stdout by default,
    # so send them to stderr to detect them
    check_opts="-d display_errors=stderr -d display_startup_errors=1"

    PHP_ERROR="$(php $check_opts -v 2>&1 1>/dev/null)"

    if [ -n "${PHP_ERROR}" ]; then
        echo "${PHP_ERROR}"
        echo "ERROR: PHP failed to load its extensions. Is a disabled extension required by another one (e.g. igbinary or msgpack by redis)?" >&2
        false
    fi

    PHP_ERROR="$(php $check_opts -i 2>&1 1>/dev/null)"

    if [ -n "${PHP_ERROR}" ]; then
        echo "${PHP_ERROR}"
        false
    fi

    PHP_FPM_ERROR="$(php-fpm $check_opts -v 2>&1 1>/dev/null)"

    if [ -n "${PHP_FPM_ERROR}" ]; then
        echo "${PHP_FPM_ERROR}"
        false
    fi

    PHP_FPM_ERROR="$(php-fpm $check_opts -i 2>&1 1>/dev/null)"

    if [ -n "${PHP_FPM_ERROR}" ]; then
        echo "${PHP_FPM_ERROR}"
        false
    fi

    echo "Tests were successful!"
    echo
fi

exec "$@"
