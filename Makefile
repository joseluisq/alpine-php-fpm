dev:
	@php -S localhost:8088 -t .
.PHONY: dev

build-php-fpm:
	@docker build -t alpine-php-fpm:latest -f php-fpm/Dockerfile .
.PHONY: build-php-fpm

build-php-fpm-nginx:
	@docker build -t alpine-php-fpm-nginx:latest -f php-fpm-nginx/Dockerfile .
.PHONY: build-php-fpm-nginx

run:
	@docker run --rm -it \
		-v $(PWD)/public:/usr/share/nginx/html \
		--workdir /usr/share/nginx/html \
		-p 8088:80 \
		alpine-php-fpm:latest
.PHONY: run

promote:
	@drone build promote joseluisq/alpine-php-fpm $(BUILD) $(ENV)
.PHONY: p

loadtest:
	@echo "GET http://localhost:8088" | \
		vegeta -cpus=12 attack -workers=10 -duration=60s -connections=10000 -rate=200 -http2=false > results.bin
	@cat results.bin | vegeta report -type='hist[0,2ms,4ms,6ms]'
	@cat results.bin | vegeta plot > plot.html
.PHONY: loadtest
