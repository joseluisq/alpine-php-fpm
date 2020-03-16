# Alpine / Nginx / PHP-FPM [![Docker Image](https://img.shields.io/docker/pulls/joseluisq/alpine-nginx-php-fpm.svg)](https://hub.docker.com/r/joseluisq/alpine-nginx-php-fpm/)

> [Nginx v1.7](https://nginx.org/en/) configured with [PHP-FPM (PHP v7.4)](https://www.php.net/manual/en/install.fpm.php) on top of [Alpine Linux v3.11](https://alpinelinux.org/) x86_64.

## Features

- **Nginx v1.7**
- **PHP v7.4**
    - Extensions: bcmath, bz2, gd, gmp, xmlrpc, intl, mysqli, opcache, pcntl, pdo_dblib, pdo_mysql, soap, zip
- **Composer v1.9**

## Usage

```sh
docker run --rm -it \
    -v $PWD:/usr/share/nginx/html \
    --workdir /usr/share/nginx/html \
    -p 8088:80 \
    joseluisq/alpine-nginx-php-fpm:1
```

## Contributions

Feel free to send a [pull request](https://github.com/joseluisq/alpine-nginx-php-fpm/pulls) or file some [issue](https://github.com/joseluisq/alpine-nginx-php-fpm/issues).

## License

MIT license

© 2020 [Jose Quintana](https://git.io/joseluisq)
