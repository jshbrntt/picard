ifndef PICARD_CHECK_MAKE_MODULE
PICARD_CHECK_MAKE_MODULE := 1

RELATIVE_PATH := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(RELATIVE_PATH)/log.mk
include $(RELATIVE_PATH)/version.mk

# Ensure supported make version is available.
UNSUPPORTED_MAKE_VERSION := 5.0
SUPPORTED_MAKE_VERSION := 4.3

$(call PICARD_LOG_INFO,Make version: $(MAKE_VERSION) (supported >=$(SUPPORTED_MAKE_VERSION), <$(UNSUPPORTED_MAKE_VERSION)))

MAKE_VERSION_GREATER_EQUAL := $(call version_greater_equal,$(MAKE_VERSION),$(SUPPORTED_MAKE_VERSION))
MAKE_VERSION_LESS := $(call version_less,$(MAKE_VERSION),$(UNSUPPORTED_MAKE_VERSION))

$(if $(MAKE_VERSION_GREATER_EQUAL),,$(error error: make: minimum required version: $(SUPPORTED_MAKE_VERSION) (found: $(MAKE_VERSION))))
$(if $(MAKE_VERSION_LESS),,$(warning warning: make: expected version below: $(UNSUPPORTED_MAKE_VERSION) (found: $(MAKE_VERSION))))

endif
