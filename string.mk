ifndef PICARD_STRING_MODULE
PICARD_STRING_MODULE := 1

RELATIVE_PATH := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(RELATIVE_PATH)/constants.mk

# Set the separator for the *_TABLE variables, needed as otherwise `$(addprefix ...)` fails.
__case_prefix := ,

# Define the upper and lower cased characters.
__lowercase_characters := a b c d e f g h i j k l m n o p q r s t u v w x y z
__uppercase_characters := A B C D E F G H I J K L M N O P Q R S T U V W X Y Z

# Join the above to create the *_TABLE variables (i.e `a,A b,B ...`, `A,a B,b ...`).
__lowercase_table := $(join $(__uppercase_characters),$(addprefix $(__case_prefix),$(__lowercase_characters)))
__uppercase_table := $(join $(__lowercase_characters),$(addprefix $(__case_prefix),$(__uppercase_characters)))

# An internal macro to recursively create `$(subst ...)` from provided *_TABLE and string, (e.g. `$(subst a,A,$(subst b,B,...))`).
__convert_case = $(if $1,$$(subst $(firstword $1),$(call __convert_case,$(wordlist 2,$(words $1),$1),$2)),$2)

# The actual macros to $(call ...), which calls the __convert_case with the correct *_TABLE.

# Utility for converting strings between cases.
#
# Source: https://stackoverflow.com/a/73181226
#
# Example Usage:
#
#     ```makefile
#     include string.mk
#
#     INPUT ?= Hello World!
#
#     .PHONY: uppercase
#     uppercase:
#     	@echo $(call uppercase,$(INPUT))
#
#     .PHONY: lowercase
#     lowercase:
#     	@echo $(call lowercase,$(INPUT))
#     ```
#
#     ```shell
#     $ make uppercase
#     HELLO WORLD!
#     
#     $ make lowercase
#     hello world!
#     ```
#
lowercase = $(eval __lowercase_result := $(call __convert_case,$(__lowercase_table),$1))$(__lowercase_result)
uppercase = $(eval __uppercase_result := $(call __convert_case,$(__uppercase_table),$1))$(__uppercase_result)

string_equal = $(if $(subst $1,,$2),$(EMPTY),1)
string_less = $(call string_equal,$(word 1,$(sort $1 $2)),$1)
string_greater = $(call string_equal,$(word 1,$(sort $1 $2)),$2)

endif
