TAG ?= $(shell date '+%Y%m%d')
REPO ?= ghcr.io/feiyudev
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