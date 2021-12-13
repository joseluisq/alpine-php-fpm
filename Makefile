dev:
	@php -S localhost:8088 -t .
.PHONY: dev

buildx-fpm-74:
	@echo "Building PHP 7.4 Docker images (linux/amd64,linux/arm64)..."
	@docker buildx build -t joseluisq/php-fpm:7.4 --platform linux/amd64,linux/arm64 -f 7.4-fpm/Dockerfile .
.PHONY: buildx-fpm-74

buildx-fpm-80:
	@echo "Building PHP 8.0 Docker images (linux/amd64,linux/arm64)..."
	@docker buildx build -t joseluisq/php-fpm:8.0 --platform linux/amd64,linux/arm64 -f 8.0-fpm/Dockerfile .
.PHONY: buildx-fpm-80

buildx-fpm-81:
	@echo "Building PHP 8.1 Docker images (linux/amd64,linux/arm64)..."
	@docker buildx build -t joseluisq/php-fpm:8.1 --platform linux/amd64,linux/arm64 -f 8.1-fpm/Dockerfile .
.PHONY: buildx-fpm-81

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
