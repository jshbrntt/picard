ifndef PICARD_CHECK_DOCKER_MODULE
PICARD_CHECK_DOCKER_MODULE := 1

RELATIVE_PATH := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(RELATIVE_PATH)/version.mk
include $(RELATIVE_PATH)/list.mk

# Ensure supported docker version is available.
UNSUPPORTED_DOCKER_VERSION := 24.0.0
SUPPORTED_DOCKER_VERSION := 20.0.0
DOCKER_VERSION := $(shell docker version --format '{{ .Server.Version }}')

$(if $(PICARD_DEBUG),$(call PICARD_LOG_INFO,Docker version: $(DOCKER_VERSION) (supported >=$(SUPPORTED_DOCKER_VERSION), <$(UNSUPPORTED_DOCKER_VERSION))))

# Check docker was detected on the system.
$(if $(DOCKER_VERSION),,$(call PICARD_LOG_ERROR,unable to test docker version (not installed?)))
# Check docker version is within supported range.

DOCKER_VERSION_GREATER_EQUAL := $(call version_greater_equal,$(DOCKER_VERSION),$(SUPPORTED_DOCKER_VERSION))
DOCKER_VERSION_LESS := $(call version_less,$(DOCKER_VERSION),$(UNSUPPORTED_DOCKER_VERSION))

DOCKER_BUILDX_INSPECT := $(shell DEBUG=1 docker buildx inspect)
DOCKER_CACHE_EXPORT := $(findstring true,$(word $(shell expr $(call list_index_of,Cache,$(DOCKER_BUILDX_INSPECT)) + 2),$(DOCKER_BUILDX_INSPECT)))
$(if $(DOCKER_CACHE_EXPORT),,$(call PICARD_LOG_ERROR,docker: cache export not supported (enable containerd image store, or use a different driver)))
# docker info -f '{{ .DriverStatus }}'

$(if $(DOCKER_VERSION_GREATER_EQUAL),,$(call PICARD_LOG_ERROR,docker: minimum required version: $(SUPPORTED_DOCKER_VERSION) (found: $(DOCKER_VERSION))))
$(if $(DOCKER_VERSION_LESS),,$(call PICARD_LOG_WARNING,docker: expected version below: $(UNSUPPORTED_DOCKER_VERSION) (found: $(DOCKER_VERSION))))

endif
