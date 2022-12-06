# Alpine PHP-FPM [![devel](https://github.com/joseluisq/alpine-php-fpm/workflows/devel/badge.svg)](https://github.com/joseluisq/alpine-php-fpm/actions?query=workflow%3Adevel) [![Docker Image](https://img.shields.io/docker/pulls/joseluisq/php-fpm.svg)](https://hub.docker.com/r/joseluisq/php-fpm/)

> Lightweight & optimized [PHP-FPM](https://www.php.net/manual/en/install.fpm.php) (PHP [8.0](https://www.php.net/ChangeLog-8.php#PHP_8_0) and [8.1](https://www.php.net/ChangeLog-8.php#PHP_8_1)) Multi-Arch Docker images (`x86_64`/`arm`/`arm64`) with essential extensions on top of latest [Alpine Linux](https://alpinelinux.org/).

### PHP 8.0

![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/joseluisq/php-fpm/8.0) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/joseluisq/php-fpm/8.0)

### PHP 8.1

![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/joseluisq/php-fpm/8.1) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/joseluisq/php-fpm/8.1)

### Built-in extensions

`curl`, `ftp`, `hash` (`mhash`), `libedit`, `libsodium`, `mbstring`, `mysqlnd`, `openssl`, `password-argon2`, `pdo-sqlite`, `pear`, `sqlite3`, `zlib`

### Additional extensions

| Extension  |   v8.0 |   v8.1 |
| ---------- | -----: | -----: |
| amqp       |      ✓ |      ✓ |
| apcu       |      ✓ |      ✓ |
| bcmath     |      ✓ |      ✓ |
| bz2        |      ✓ |      ✓ |
| exif       |      ✓ |      ✓ |
| gd         |      ✓ |      ✓ |
| gettext    |      ✓ |      ✓ |
| gmp        |      ✓ |      ✓ |
| imagick    |      ✓ |      ✓ |
| imap       |      ✓ |      ✓ |
| intl       |      ✓ |      ✓ |
| mcrypt     |      ✓ |      ? |
| memcache   |      ✓ |      ✓ |
| mongodb    |      ✓ |      ✓ |
| mysqli     |      ✓ |      ✓ |
| oauth      |      ✓ |      ✓ |
| opcache    |      ✓ |      ✓ |
| pcntl      |      ✓ |      ✓ |
| pdo_dblib  |      ✓ |      ✓ |
| pdo_mysql  |      ✓ |      ✓ |
| pdo_pgsql  |      ✓ |      ✓ |
| pdo_sqlsrv |      ✓ |      ✓ <sup>(64-bit only)</sub> |
| pgsql      |      ✓ |      ✓ |
| phalcon    |      ? |        |
| psr        |      ✓ |      ✓ |
| redis      |      ✓ |      ✓ |
| rdkafka    |      ✓ |      ✓ |
| soap       |      ✓ |      ✓ |
| sockets    |      ✓ |      ✓ |
| sqlsrv     |      ✓ |      ✓ <sup>(64-bit only)</sub> |
| ssh2       |      ✓ |      ✓ |
| swoole     |      ✓ |      ✓ |
| sysvmsg    |      ✓ |      ✓ |
| sysvsem    |      ✓ |      ✓ |
| sysvshm    |      ✓ |      ✓ |
| tidy       |      ✓ |      ✓ |
| vips       |      ✓ |      ✓ |
| xsl        |      ✓ |      ✓ |
| yaml       |      ✓ |      ✓ |
| zip        |      ✓ |      ✓ |
| &nbsp;     | &nbsp; | &nbsp; |
| **Others** |        |        |
| composer   |   v2.4 |   v2.4 |

**Footnotes**

(?) It means that this extension is obsolete/unmaintained/discourage or simply is not supported yet.

### List all extensions included

If you want to know the whole list of the included extensions then use `php -m` as follow.

```
docker run --rm joseluisq/php-fpm:8.1 php -m
```

Or use `php -i` to get a more detailed information.

## Usage

```sh
docker pull joseluisq/php-fpm:8.0
# Or
docker pull joseluisq/php-fpm:8.1

```

🐳 Available on Docker Hub → [hub.docker.com/r/joseluisq/php-fpm](https://hub.docker.com/r/joseluisq/php-fpm/)

### Dockerfile

```Dockerfile
FROM joseluisq/php-fpm:8.0
# Or
FROM joseluisq/php-fpm:8.1
```

### Run a container

To give a Docker image a quick try, just execute any of those commands and then navigate to [localhost:8088](http://localhost:8088)

```sh
docker run --rm -p 8088:80 joseluisq/php-fpm:8.1 sh -c "echo '<?php phpinfo();' > index.php; php -S [::]:80 -t ."
# Or
docker run --rm -p 8088:80 joseluisq/php-fpm:8.0 sh -c "echo '<?php phpinfo();' > index.php; php -S [::]:80 -t ."
```

[View Docker Compose Examples](#docker-compose-examples)

## Default Paths

- Default Docker working directory: `/var/www/html`
- Additional PHP `.ini` files to load: `/usr/local/etc/php/conf.d`
- Custom PHP `.ini` file generated (only if `ENV_SUBSTITUTION_ENABLE=true`): `/usr/local/etc/php/conf.d/default-php.ini`

## Configurable Environment Variables

**PHP-FPM** and **PHP** configurations can be overwritten using environment variables.
To do it so, just indicates the substitution of values using `ENV_SUBSTITUTION_ENABLE=true` (since it is disabled by default).

Below the environment variables with their default values:

### PHP-FPM

#### Global FPM

Settings replaced into `/usr/local/etc/php-fpm.conf` file.

- `PHP_FPM_ERROR_LOG=/proc/self/fd/2`
- `PHP_FPM_LOG_LEVEL=error`

#### FPM WWW Pool

Settings replaced into `/usr/local/etc/php-fpm.d/www.conf` file.

- `PHP_FPM_LISTEN=9000`
- `PHP_FPM_USER=www-data`
- `PHP_FPM_GROUP=www-data`
- `PHP_FPM_LISTEN_OWNER=www-data`
- `PHP_FPM_LISTEN_GROUP=www-data`

### PHP Config

Settings replaced into `/usr/local/etc/php/conf.d/default-php.ini` file (`php.ini`).

- `PHP_MEMORY_LIMIT=512M`
- `PHP_EXPOSE_PHP=On`
- `PHP_SESSION_GC_MAXLIFETIME=1440`

## Docker Compose Examples

[docker-compose](https://docs.docker.com/compose/) examples for [Nginx](https://hub.docker.com/_/nginx) and [Apache](https://hub.docker.com/_/httpd) servers can be found under the [./examples](./examples) directory.

### Nginx example

```sh
docker-compose -f examples/nginx/docker-compose.yml up
```

### Apache example

```sh
docker-compose -f examples/apache/docker-compose.yml up
```

## Contributions

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in current work by you, as defined in the Apache-2.0 license, shall be dual licensed as described below, without any additional terms or conditions.

Feel free to send some [pull request](https://github.com/joseluisq/alpine-php-fpm/pulls) or file some [issue](https://github.com/joseluisq/alpine-php-fpm/issues).

## License

This work is primarily distributed under the terms of both the [MIT license](LICENSE-MIT) and the [Apache License (Version 2.0)](LICENSE-APACHE).

© 2020-present [Jose Quintana](https://joseluisq.net)
