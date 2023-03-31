# Enable debug logging
DEBUG ?=

ifdef DEBUG
MAKECMDGOALS += debug
endif
MAKEFLAGS += --no-print-directory$(if $(DEBUG), --debug)
CWD_PATH := $(realpath .)
CWD_BASENAME := $(notdir $(CWD_PATH))
PROJECT ?= example
PROJECT_PATH ?= $(CWD_PATH)/$(PROJECT)
WORKING_DIRECTORY ?= /usr/src/$(notdir $(PROJECT_PATH))
IMAGE_NAME ?= picard
IMAGE_TAG ?= latest
SERVICE ?= project
REGISTRY_HOSTNAME ?= ghcr.io
IMAGE ?= $(REGISTRY_HOSTNAME)/$(IMAGE_NAME):$(IMAGE_TAG)
BUILDKIT_PROGRESS ?= plain
BUILDKIT_INLINE_CACHE ?= 1
DOCKER ?= docker
DOCKER_COMPOSE ?= $(DOCKER) compose --file docker-compose.yaml --file docker-compose.$(if $(CI),ci,dev).yaml
DOCKER_SCAN ?=

DOCKER_REGISTRY_USERPASS := $(subst :, ,$(DOCKER_REGISTRY_AUTH))
DOCKER_REGISTRY_USERNAME := $(word 1,$(DOCKER_REGISTRY_USERPASS))
DOCKER_REGISTRY_PASSWORD := $(word 2,$(DOCKER_REGISTRY_USERPASS))

# https://www.gnu.org/software/make/manual/html_node/Special-Targets.html
.ONESHELL:
.NOTPARALLEL:
.EXPORT_ALL_VARIABLES:

ifeq ($(MAKELEVEL),0)

MAKECMDGOALS ?= notarget
.PHONY: $(MAKECMDGOALS)
$(MAKECMDGOALS):
	$(MAKE) $(if $(findstring notarget,$(MAKECMDGOALS)),,$(MAKECMDGOALS))

else

.PHONY: default
default: shell

.PHONY: require-%
require-%:
	@#$(or ${$*}, $(error $* is not set))

.PHONY: required-login-variables
required-login-variables: require-DOCKER_REGISTRY_URL
required-login-variables: require-DOCKER_REGISTRY_USERNAME
required-login-variables: require-DOCKER_REGISTRY_PASSWORD

.PHONY: login
login: required-login-variables
login:
	echo $(DOCKER_REGISTRY_PASSWORD) | $(DOCKER) login --password-stdin --username $(DOCKER_REGISTRY_USERNAME) $(DOCKER_REGISTRY_URL)

.PHONY: config
config:
	printenv
	$(DOCKER_COMPOSE) config

.PHONY: debug
debug: config

.PHONY: push
push:
	$(DOCKER_COMPOSE) push $(SERVICE)

.PHONY: required-common-variables
required-common-variables: require-IMAGE
required-common-variables: require-WORKING_DIRECTORY

.PHONY: required-build-variables
required-build-variables: required-common-variables

.PHONY: scan
scan:
	$(if $(DOCKER_SCAN),$(DOCKER) scan --accept-license $(IMAGE))

.PHONY: build
build: required-build-variables
build: $(if $(DOCKER_SCAN),scan)
build: $(if $(CI),login)
	$(DOCKER_COMPOSE) build --pull $(if $(NO_CACHE),--no-cache )$(SERVICE)

.PHONY: exec
exec:
	$(DOCKER_COMPOSE) exec $(SERVICE) $(COMMAND)

.PHONY: required-run-variables
required-run-variables: required-common-variables

.PHONY: run
run: build
run: required-run-variables
	$(DOCKER_COMPOSE) run --rm --service-ports $(if $(COMMAND),--entrypoint '' )$(SERVICE) $(COMMAND)

.PHONY: command
command:
	$(MAKE) $(if $(shell $(DOCKER_COMPOSE) ps --quiet --all --status running $(SERVICE)),exec,run)

.PHONY: shell
shell: COMMAND := sh
shell: command

.PHONY: start
start: COMMAND := yarn --silent start
start: command

.PHONY: test
test: COMMAND := yarn --silent test
test: command

endif
