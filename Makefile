dev:
	@php -S localhost:8088 -t .
.PHONY: dev

build-fpm-74:
	@docker build -t alpine-php-fpm:latest -f 7.4-fpm/Dockerfile .
.PHONY: build-fpm-74

run:
	@docker run --rm -it \
		-v $(PWD)/public:/usr/share/nginx/html \
		--workdir /usr/share/nginx/html \
		-p 8088:80 \
		alpine-php-fpm:latest
.PHONY: run

compose:
	@docker-compose -f sample/docker-compose.yml up
.PHONY: compose

promote:
	@drone build promote joseluisq/alpine-php-fpm $(BUILD) $(ENV)
.PHONY: p

loadtest:
	@echo "GET http://localhost:8088" | \
		vegeta -cpus=12 attack -workers=10 -duration=60s -connections=10000 -rate=200 -http2=false > results.bin
	@cat results.bin | vegeta report -type='hist[0,2ms,4ms,6ms]'
	@cat results.bin | vegeta plot > plot.html
.PHONY: loadtest
