ifndef PICARD_CONSTANTS_MODULE
PICARD_CONSTANTS_MODULE := 1

RELATIVE_PATH := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(RELATIVE_PATH)/string.mk

# Empty value
EMPTY :=

# Space value.
SPACE := $(EMPTY) $(EMPTY)

# Current working directory path relative to this file.
CWD_PATH := $(realpath .)

# Current working directory basename.
CWD_BASENAME := $(notdir $(CWD_PATH))

# Project name derived from root directory name.
PROJECT_NAME := $(call lowercase,$(CWD_BASENAME))

endif
