ifndef PICARD_LIST_MODULE
PICARD_LIST_MODULE := 1

RELATIVE_PATH := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(RELATIVE_PATH)/constants.mk

# Utility for joining a list of a specified character.
#
# Example Usage:
#
#     ```makefile
#     include string.mk
#
#     COMMA := ,
#     .PHONY: csv
#     csv: COMMA := 
#     	@echo $(call join,$(COMMA),email name phone_number location)
#     ```
#
#     ```shell
#     $ make csv
#     email,name,phone_number,location
#     ```
#
list_join = $(subst $(SPACE),$1,$(strip $2))

# Utility for generating a range of numbers between a specified start and end index.
#
# Example Usage:
#
#     ```makefile
#     include string.mk
#
#     START ?= 1
#     END ?= 10
#
#     .PHONY: range
#     range:
#     	@echo $(call list_range,$(START),$(END))
#     ```
#
#     ```shell
#     $ make range
#     1 2 3 4 5 6 7 8 9 10
#
#     $ make START=3 END=8 range
#     3 4 5 6 7 8
#     ```
#
list_range = $(if $(word ${2},${3}),$(wordlist ${1},${2},${3}),$(call list_range,${1},${2},${3} $(words _ ${3})))

# Utility for finding the position index of a word in a list.
#
# Example Usage:
#
#     ```makefile
#     include string.mk
#
#     WORD_LIST ?= alpha beta gamma delta epsilon
#
#     .PHONY: index
#     index:
#     	@echo $(call list_index_of,$(INPUT),$(WORD_LIST))
#     ```
#
#     ```shell
#     $ make INPUT=beta index
#     2
#
#     $ make INPUT=delta index
#     4
#
#     $ make INPUT=zeta index
#     0
#     ```
#
__position_count_accumalator = $(if $(findstring ${1},${2}),$(call __position_count_accumalator,${1},$(wordlist 2,$(words ${2}),${2}),x ${3}),${3})
list_index_of = $(words $(call __position_count_accumalator,${1},${2}))

endif
