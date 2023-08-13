ifndef PICARD_VERSION_MODULE
PICARD_VERSION_MODULE := 1

RELATIVE_PATH := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(RELATIVE_PATH)/constants.mk
include $(RELATIVE_PATH)/string.mk
include $(RELATIVE_PATH)/list.mk

# Creates a list of digits from a number
__split_digits = $(eval __tmp := $1)$(foreach i,0 1 2 3 4 5 6 7 8 9,$(eval __tmp := $$(subst $$i,$$i ,$(__tmp))))$(__tmp)
__number_less = $(eval __tmp1 := $(call __split_digits,$1))$(eval __tmp2 := $(call __split_digits,$2))$(if $(call string_equal,$(words $(__tmp1)),$(words $(__tmp2))),$(call string_less,$1,$2),$(call string_less,$(words $(__tmp1)),$(words $(__tmp2))))
__number_greater = $(eval __tmp1 := $(call __split_digits,$1))$(eval __tmp2 := $(call __split_digits,$2))$(if $(call string_equal,$(words $(__tmp1)),$(words $(__tmp2))),$(call string_greater,$1,$2),$(call string_greater,$(words $(__tmp1)),$(words $(__tmp2))))

# Strip zeroes from the beginning of a list
__unshift_zeroes = $(eval __flag := 1)$(foreach __digit,$1,$(if $(__flag),$(if $(subst 0,,$(__digit)),$(eval __flag :=)$(__digit),$(EMPTY)),$(__digit)))

# temp string: 0 - two number equals, L first LT, G first GT or second is short,
__gen_cmpstr = $(eval __digit_list_a := $(subst ., ,$1))$(eval __digit_list_b := $(subst ., ,$2))$(foreach __index,$(call list_range,1,$(words $(__digit_list_a))),$(eval __digit_a := $(word $(__index),$(__digit_list_a)))$(eval __digit_b := $(word $(__index),$(__digit_list_b)))$(if $(call string_equal,$(__digit_a),$(__digit_b)),0,$(if $(call __number_less,$(__digit_a),$(__digit_b)),L,G)))

version_less = $(call string_equal,$(word 1,$(call __unshift_zeroes,$(call __gen_cmpstr,$1,$2))),L)
version_less_equal = $(eval __cmpstr := $(word 1,$(call __unshift_zeroes,$(call __gen_cmpstr,$1,$2))))$(if $(__cmpstr),$(call string_equal,$(__cmpstr),L),1)
version_greater = $(call string_equal,$(word 1,$(call __unshift_zeroes,$(call __gen_cmpstr,$1,$2))),G)
version_greater_equal = $(eval __cmpstr := $(word 1,$(call __unshift_zeroes,$(call __gen_cmpstr,$1,$2))))$(if $(__cmpstr),$(call string_equal,$(__cmpstr),G),1)

endif
