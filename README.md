<div>
  <div align="center">
    <a href="https://php.net">
      <img
        alt="PHP"
        src="https://www.php.net/images/logos/new-php-logo.svg"
        width="150">
    </a>
  </div>

  <h1 align="center">Alpine PHP-FPM</h1>

  <h4 align="center">
    Lightweight & optimized <a href="https://www.docker.com/blog/how-to-rapidly-build-multi-architecture-images-with-buildx/">Multi-Arch Docker Images</a> (<code>x86_64</code>/<code>arm</code>/<code>arm64</code>) for <a href="https://www.php.net/manual/en/install.fpm.php">PHP-FPM</a> (PHP <a href="https://www.php.net/ChangeLog-8.php#PHP_8_1">8.1</a>, <a href="https://www.php.net/ChangeLog-8.php#PHP_8_2">8.2</a>, <a href="https://www.php.net/ChangeLog-8.php#PHP_8_3">8.3</a>) with essential extensions on top of latest Alpine Linux. 🐘
  </h4>

  <div align="center">
    <a href="https://github.com/joseluisq/alpine-php-fpm/actions/workflows/devel-8.3.yml" title="devel 8.3 (latest)"><img src="https://github.com/joseluisq/alpine-php-fpm/actions/workflows/devel-8.3.yml/badge.svg"></a> 
    <a href="https://hub.docker.com/r/joseluisq/php-fpm/" title="Docker Image Version (tag latest semver)"><img src="https://img.shields.io/docker/v/joseluisq/php-fpm/8"></a> 
    <a href="https://hub.docker.com/r/joseluisq/php-fpm/tags" title="Docker Image Size (tag)"><img src="https://img.shields.io/docker/image-size/joseluisq/php-fpm/8"></a> 
    <a href="https://hub.docker.com/r/joseluisq/php-fpm/" title="Docker Image"><img src="https://img.shields.io/docker/pulls/joseluisq/php-fpm.svg"></a> 
  </div>
</div>

## Stable versions

|   v8.1 |   v8.2 |   v8.3 |
| -----: | -----: | -----: |
| ![Docker Image 8.1 (tag 8.1 semver)](https://img.shields.io/docker/v/joseluisq/php-fpm/8.1)<br> ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/joseluisq/php-fpm/8.1) | ![Docker Image 8.2 (tag 8.2 semver)](https://img.shields.io/docker/v/joseluisq/php-fpm/8.2)<br> ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/joseluisq/php-fpm/8.2) | ![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/joseluisq/php-fpm/8.3)<br> ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/joseluisq/php-fpm/8.3) |

### PHP versions support

We **only** support stable PHP versions according to the [PHP Release Cycle](https://www.php.net/supported-versions.php). 
However, you can still find legacy versions like `7.4.x` or `8.0.x` on [Releases](https://github.com/joseluisq/alpine-php-fpm/releases) and [Docker Hub](https://hub.docker.com/r/joseluisq/php-fpm/).

## Built-in extensions

`curl`, `ftp`, `hash` (`mhash`), `libedit`, `libsodium`, `mbstring`, `mysqlnd`, `openssl`, `password-argon2`, `pdo-sqlite`, `pear`, `sqlite3`, `zlib`

## Additional extensions

| Extension  |   v8.1 |   v8.2 |   v8.3 |
| ---------- | -----: | -----: | -----: |
| amqp       |      ✓ |      ✓ |      ✓ |
| apcu       |      ✓ |      ✓ |      ✓ |
| bcmath     |      ✓ |      ✓ |      ✓ |
| bz2        |      ✓ |      ✓ |      ✓ |
| exif       |      ✓ |      ✓ |      ✓ |
| gd         |      ✓ |      ✓ |      ✓ |
| gettext    |      ✓ |      ✓ |      ✓ |
| gmp        |      ✓ |      ✓ |      ✓ |
| imagick    |      ✓ |      ✓ |      ✓ |
| igbinary   |      ✓ |      ✓ |      ✓ |
| imap       |      ✓ |      ✓ |      ✓ |
| intl       |      ✓ |      ✓ |      ✓ |
| lz4        |      ✓ |      ✓ |      ✓ |
| memcache   |      ✓ |      ✓ |      ✓ |
| mongodb    |      ✓ |      ✓ |      ✓ |
| msgpack    |      ✓ |      ✓ |      ✓ |
| mysqli     |      ✓ |      ✓ |      ✓ |
| oauth      |      ✓ |      ✓ |      ✓ |
| opcache    |      ✓ |      ✓ |      ✓ |
| pcntl      |      ✓ |      ✓ |      ✓ |
| pdo_dblib  |      ✓ |      ✓ |      ✓ |
| pdo_mysql  |      ✓ |      ✓ |      ✓ |
| pdo_pgsql  |      ✓ |      ✓ |      ✓ |
| pdo_sqlsrv |      ✓ <sup>(64-bit only)</sub> |     ✓ <sup>(64-bit only)</sub> |     ✓ <sup>(64-bit only)</sub> |
| pgsql      |      ✓ |      ✓ |      ✓ |
| phalcon    |      ✓ |      ✓ |      ✓ |
| psr        |      ✓ |      ✓ |      ✓ |
| redis      |      ✓ |      ✓ |      ✓ |
| rdkafka    |      ✓ |      ✓ |      ✓ |
| soap       |      ✓ |      ✓ |      ✓ |
| sockets    |      ✓ |      ✓ |      ✓ |
| sqlsrv     |      ✓ <sup>(64-bit only)</sub> |    ✓ <sup>(64-bit only)</sub> |    ✓ <sup>(64-bit only)</sub> |
| ssh2       |      ✓ |      ✓ |      ✓ |
| swoole     |      ✓ <sup>(64-bit only)</sub> |      ✓ <sup>(64-bit only)</sub> |      ✓ <sup>(64-bit only)</sub> |
| sysvmsg    |      ✓ |      ✓ |      ✓ |
| sysvsem    |      ✓ |      ✓ |      ✓ |
| sysvshm    |      ✓ |      ✓ |      ✓ |
| tidy       |      ✓ |      ✓ |      ✓ |
| uuid       |      ✓ |      ✓ |      ✓ |
| vips       |      ✓ |      ✓ |      ✓ |
| xdebug     |      ✓ |      ✓ |      ✓ |
| xsl        |      ✓ |      ✓ |      ✓ |
| yaml       |      ✓ |      ✓ |      ✓ |
| zip        |      ✓ |      ✓ |      ✓ |
| zstd       |      ✓ |      ✓ |      ✓ |
| &nbsp;     | &nbsp; | &nbsp; | &nbsp; |
| **Others** |        |        |        |
| composer   |   v2.7 |   v2.8 |   v2.8 |
| &nbsp;     | &nbsp; | &nbsp; | &nbsp; |
| **Extensions file**   |   [8.1-fpm/extensions.txt](8.1-fpm/extensions.txt) |  [8.2-fpm/extensions.txt](8.2-fpm/extensions.txt)  |  [8.3-fpm/extensions.txt](8.3-fpm/extensions.txt)  |

**Footnotes**

- (?) It means that this extension is obsolete/unmaintained/discouraged or simply is not supported yet.
- The `mcrypt` extension is obsolete. Use `libsodium` or `openssl` instead.

### List all extensions included

If you want to know the whole list of the included extensions then type `php -m` as follows.

```sh
docker run --rm joseluisq/php-fpm:8.3 php -m
```

Or use `php -i` to get more detailed information.

## Usage

```sh
docker pull joseluisq/php-fpm:8.3
# Or
docker pull joseluisq/php-fpm:8.2
# Or
docker pull joseluisq/php-fpm:8.1
```

🐳 Available on Docker Hub → [hub.docker.com/r/joseluisq/php-fpm](https://hub.docker.com/r/joseluisq/php-fpm/)

### Dockerfile

```Dockerfile
FROM joseluisq/php-fpm:8.3
# Or
FROM joseluisq/php-fpm:8.2
# Or
FROM joseluisq/php-fpm:8.1
```

### Run a container

To give a Docker image a quick try, just execute any of those commands and then navigate to [localhost:8088](http://localhost:8088)

```sh
docker run --rm -p 8088:80 joseluisq/php-fpm:8.3 sh -c "echo '<?php phpinfo();' > index.php; php -S [::]:80 -t ."
# Or
docker run --rm -p 8088:80 joseluisq/php-fpm:8.2 sh -c "echo '<?php phpinfo();' > index.php; php -S [::]:80 -t ."
# Or
docker run --rm -p 8088:80 joseluisq/php-fpm:8.1 sh -c "echo '<?php phpinfo();' > index.php; php -S [::]:80 -t ."
```

[View Docker Compose Examples](#docker-compose-examples)

## Default paths

- Default Docker working directory: `/var/www/html`
- Additional PHP `.ini` files to load: `/usr/local/etc/php/conf.d`
- Custom PHP `.ini` file generated (only if `ENV_SUBSTITUTION_ENABLE=true`): `/usr/local/etc/php/conf.d/default-php.ini`

## Configurable Environment Variables

**PHP-FPM** and **PHP** configurations can be overwritten using environment variables.
To do so, just indicate the substitution of values using `ENV_SUBSTITUTION_ENABLE=true` (since it is disabled by default).

Below are the environment variables with their default values:

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

### Disable PHP additional extensions

The PHP additional extensions can be disabled at startup by providing the `PHP_DISABLE_EXTENSIONS` environment variable with one or more names. For example `PHP_DISABLE_EXTENSIONS=psr,exif,bz2`.

Find the valid extension names in `extensions.txt` file of every PHP version directory or by using `php -m`. For example `docker run --rm joseluisq/php-fpm:8.3 php -m | grep "exif"`.

## Docker Compose examples

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

Feel free to send some [pull request](https://github.com/joseluisq/alpine-php-fpm/pulls) or file an [issue](https://github.com/joseluisq/alpine-php-fpm/issues).

## License

This work is primarily distributed under the terms of both the [MIT license](LICENSE-MIT) and the [Apache License (Version 2.0)](LICENSE-APACHE).

© 2020-present [Jose Quintana](https://joseluisq.net)
