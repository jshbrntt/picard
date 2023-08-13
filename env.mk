ifndef PICARD_ENV_MODULE
PICARD_ENV_MODULE := 1

# Utility target for ensuring environment variable is set.
#
# Example Usage:
#
#     ```makefile
#     include string.mk
#
#     .PHONY: var
#     var: env-REQUIRED_ENVIRONMENT_VARIABLE
#     	@echo [$(REQUIRED_ENVIRONMENT_VARIABLE)] is available for use!
#.....```
#
#.... ```shell
#.... # Running target without REQUIRED_ENVIRONMENT_VARIABLE set
#     $ make var
#     string.mk:23: *** REQUIRED_ENVIRONMENT_VARIABLE is not set.  Stop.
#
#     # Set REQUIRED_ENVIRONMENT_VARIABLE
#.... $ export REQUIRED_ENVIRONMENT_VARIABLE=secret
#
#     # Running target with REQUIRED_ENVIRONMENT_VARIABLE set
#     $ make var
#     [secret] is available for use!
#     ```
#
.PHONY: env-%
env-%:
	@#$(or ${$*}, $(error $* is not set))

endif
