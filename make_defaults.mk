ifndef PICARD_MAKE_DEFAULTS_MODULE
PICARD_MAKE_DEFAULTS_MODULE := 1

.DEFAULT_GOAL := all
# Makes all commands run in the same shell.
.ONESHELL:
# Force all targets execute serially / disable the ability to execute recipes in parallel.
.NOTPARALLEL:

# pipefail: Force exit code of failed shell command is returned.
# errexit:  Force shell exits if error occurs when running the command.
SHELLOPTS := $(if $(SHELLOPTS),$(SHELLOPTS):)pipefail:errexit

# Turn off verbose sub-make logs, enable make debug logs if DEBUG is set.
MAKEFLAGS += --no-print-directory

endif
