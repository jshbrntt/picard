ifndef PICARD_MODULE
PICARD_MODULE := 1

RELATIVE_PATH := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

ifdef GITHUB_ACTIONS
include $(RELATIVE_PATH)/github_actions.mk
endif

include $(RELATIVE_PATH)/log.mk
include $(RELATIVE_PATH)/check_make.mk
include $(RELATIVE_PATH)/make_defaults.mk
include $(RELATIVE_PATH)/check_docker.mk
include $(RELATIVE_PATH)/docker.mk

endif
