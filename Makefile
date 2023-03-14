TAG=$(shell date '+%Y%m%d')

test:
	@docker build --tag esacif/simple-http-server:$(TAG) .
	@docker run -d --rm --name ubuntu -it esacif/simple-http-server:20230215 sleep 600

image:
	@docker buildx build --push --network=host --tag esacif/simple-http-server:$(TAG) --tag ghcr.io/esacif/simple-http-server:$(TAG) --platform linux/amd64,linux/arm64 .