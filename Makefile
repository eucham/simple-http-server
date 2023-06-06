TAG ?= $(shell date '+%Y%m%d')
REPO ?= esacif
ifneq ($(SV),)
SUB_VER = .$(SV)
endif
ifneq ($(INSECURE),)
INSECURE = --insecure
endif

test:
	@docker build --tag esacif/simple-http-server:$(TAG) .
	@docker run -d --rm --name ubuntu -it esacif/simple-http-server:20230215 sleep 600

image:
	@docker buildx build --push --network=host --tag esacif/simple-http-server:$(TAG) --tag esacif/simple-http-server:$(TAG) --platform linux/amd64,linux/arm64 .
	@docker buildx build --push --network=host --tag esacif/simple-http-server:latest --tag esacif/simple-http-server:latest --platform linux/amd64,linux/arm64 .

ALL_OS_ARCH = linux-arm64 linux-amd64

build-push-multiarch:
	@docker buildx build -t $(REPO)/simple-http-server:$(TAG)-linux-arm64 --platform linux/arm64 --load .
	@docker push $(REPO)/simple-http-server:$(TAG)-linux-arm64
	@docker buildx build -t $(REPO)/simple-http-server:$(TAG)-linux-amd64 --platform linux/amd64 --load .
	@docker push $(REPO)/simple-http-server:$(TAG)-linux-amd64
	@docker manifest create $(INSECURE) $(REPO)/simple-http-server:$(TAG) $(foreach osarch, $(ALL_OS_ARCH), $(REPO)/simple-http-server:$(TAG)-${osarch})
	@docker manifest push $(INSECURE) --purge $(REPO)/simple-http-server:$(TAG)
	@docker manifest inspect $(INSECURE) $(REPO)/simple-http-server:$(TAG)