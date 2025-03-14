TAG ?= $(shell date '+%Y%m%d')
REPO ?= ghcr.io/eucham
ifneq ($(SV),)
SUB_VER = .$(SV)
endif
ifneq ($(INSECURE),)
INSECURE = --insecure
endif

ARCHES = arm64 amd64

build-push-multiarch:
	@for ARCH in $ARCHES; do \
	  docker buildx build -t $(REPO)/shs:$(TAG)-$$ARCH --platform linux/$$ARCH --load --provenance=false .; \
	  docker push $(REPO)/shs:$(TAG)-$$ARCH; \
  	done
	@docker manifest create $(INSECURE) $(REPO)/shs:$(TAG) $(foreach osarch, $(ARCHES), $(REPO)/shs:$(TAG)-${osarch})
	@docker manifest push $(INSECURE) --purge $(REPO)/shs:$(TAG)
	@docker manifest inspect $(INSECURE) $(REPO)/shs:$(TAG)

build:
	docker buildx build -t $(REPO)/shs:$(TAG)$(SUB_VER) --platform linux/arm64 --load --provenance=false .

build-podman:
	@podman manifest create shs:$(TAG)
	@podman build --tls-verify=false --platform linux/arm64,linux/amd64 -f Dockerfile --manifest localhost/shs:$(TAG) .
	@podman manifest push --tls-verify=false localhost/shs:$(TAG) $(REPO)/shs:$(TAG) $(REPO)/shs:latest