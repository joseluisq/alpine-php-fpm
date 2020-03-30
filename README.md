# Alpine / PHP-FPM v7 [![Docker Image](https://img.shields.io/docker/pulls/joseluisq/php.svg)](https://hub.docker.com/r/joseluisq/php/)

> [PHP-FPM (PHP v7.4)](https://www.php.net/manual/en/install.fpm.php) with essential extensions on top of [Alpine Linux v3.11](https://alpinelinux.org/).

## Features

- **PHP v7.4**
- **Composer v1.9**
- **Extensions (built-in)**
    - hash (mhash)
    - ftp
    - mbstring
    - mysqlnd
    - password-argon2
    - libsodium
    - sqlite3
    - pdo-sqlite
    - curl
    - libedit
    - openssl
    - zlib
    - pear
- **Extensions (installed)**
    - gd
    - amqp
    - gettext
    - gmp
    - bcmath
    - exif
    - imagick
    - intl
    - mcrypt
    - xmlrpc
    - memcache
    - mysqli
    - oauth
    - pdo_mysql
    - pdo_dblib
    - pcntl
    - pdo_pgsql
    - pgsql
    - psr
    - soap
    - ssh2
    - tidy
    - xsl
    - yaml
    - vips
    - zip

## Install

```sh
docker pull joseluisq/php:fpm-7.4
```

## Nginx server

View a detailed example using a Nginx server on [./sample](./sample) directory.

## Contributions

Feel free to send a [pull request](https://github.com/joseluisq/php/pulls) or file some [issue](https://github.com/joseluisq/php/issues).

## License

MIT license

© 2020 [Jose Quintana](https://git.io/joseluisq)
