# Alpine PHP-FPM [![Build Status](https://travis-ci.com/joseluisq/alpine-php-fpm.svg?branch=master)](https://travis-ci.com/joseluisq/alpine-php-fpm) [![Docker Image](https://img.shields.io/docker/pulls/joseluisq/php-fpm.svg)](https://hub.docker.com/r/joseluisq/php-fpm/)

> PHP-FPM (PHP [v7.4](https://www.php.net/ChangeLog-7.php#PHP_7_4) and [v8.0](https://www.php.net/ChangeLog-8.php#PHP_8_0)) with essential extensions on top of [Alpine Linux v3.12](https://alpinelinux.org/).

### PHP 7.4

![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/joseluisq/php-fpm/7.4) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/joseluisq/php-fpm/7.4)

### PHP 8.0

![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/joseluisq/php-fpm/8.0) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/joseluisq/php-fpm/8.0)

### Built-in extensions
  - curl
  - ftp
  - hash (mhash)
  - libedit
  - libsodium
  - mbstring
  - mysqlnd
  - openssl
  - password-argon2
  - pdo-sqlite
  - pear
  - sqlite3
  - zlib

### Additional extensions

| Extension  |  v7.4  |   v8.0 |
| ---------- | :----: | -----: |
| amqp       |   ✓    |      ? |
| bcmath     |   ✓    |      ✓ |
| exif       |   ✓    |      ✓ |
| gd         |   ✓    |      ✓ |
| gettext    |   ✓    |      ✓ |
| gmp        |   ✓    |      ✓ |
| imagick    |   ✓    |      ? |
| intl       |   ✓    |      ✓ |
| mcrypt     |   ✓    |      ✓ |
| memcache   |   ✓    |      ✓ |
| mysqli     |   ✓    |      ✓ |
| oauth      |   ✓    |      ✓ |
| pcntl      |   ✓    |      ✓ |
| pdo_dblib  |   ✓    |      ✓ |
| pdo_mysql  |   ✓    |      ✓ |
| pdo_pgsql  |   ✓    |      ✓ |
| pgsql      |   ✓    |      ✓ |
| psr        |   ✓    |      ✓ |
| soap       |   ✓    |      ✓ |
| ssh2       |   ✓    |      ? |
| tidy       |   ✓    |      ✓ |
| vips       |   ✓    |      ✓ |
| xmlrpc     |   ✓    |      ? |
| xsl        |   ✓    |      ✓ |
| yaml       |   ✓    |      ✓ |
| zip        |   ✓    |      ✓ |
| &nbsp;     | &nbsp; | &nbsp; |
| **Others** |        |        |
| composer   |  v1.9  |   v2.0 |

## Install

🐳 Available on Docker Hub → [hub.docker.com/r/joseluisq/php-fpm](https://hub.docker.com/r/joseluisq/php/)

```sh
docker pull joseluisq/php-fpm:7.4
# Or
docker pull joseluisq/php-fpm:8.0
```

__Dockerfile__

```Dockerfile
FROM joseluisq/php-fpm:7.4
# Or
FROM joseluisq/php-fpm:8.0
```

## Environment variables

**PHP-FPM** and **PHP** configurations can be overwritten using environment variables.
For do it, just indicates the substitution of values using `ENV_SUBSTITUTION_ENABLE=true`.

Below the environment variables with their default values:

#### PHP-FPM

Settings replaced into `www.conf` file.

- `PHP_FPM_LISTEN=9000`
- `PHP_FPM_USER=www-data`
- `PHP_FPM_GROUP=www-data`
- `PHP_FPM_LISTEN_OWNER=www-data`
- `PHP_FPM_LISTEN_GROUP=www-data`

#### PHP Config

Settings replaced into `php.ini` file.

- `PHP_MEMORY_LIMIT=512M`
- `PHP_SESSION_GC_MAXLIFETIME=1440`

## Example

A `docker-compose` example using a **Nginx server** can be found under [./sample](./sample) directory.

## Contributions

Feel free to send a [pull request](https://github.com/joseluisq/alpine-php-fpm/pulls) or file some [issue](https://github.com/joseluisq/alpine-php-fpm/issues).


## Contributions

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in current work by you, as defined in the Apache-2.0 license, shall be dual licensed as described below, without any additional terms or conditions.

Feel free to send some [Pull request](https://github.com/joseluisq/alpine-php-fpm/pulls) or [issue](https://github.com/joseluisq/alpine-php-fpm/issues).

## License

This work is primarily distributed under the terms of both the [MIT license](LICENSE-MIT) and the [Apache License (Version 2.0)](LICENSE-APACHE).

© 2020-present [Jose Quintana](https://git.io/joseluisq)
