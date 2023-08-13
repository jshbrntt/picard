ifndef PICARD_DOCKER_MODULE
PICARD_DOCKER_MODULE := 1

RELATIVE_PATH := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(RELATIVE_PATH)/env.mk
include $(RELATIVE_PATH)/constants.mk
include $(RELATIVE_PATH)/list.mk

# Base Docker command.
DOCKER ?= docker
# Force caching of all layers, even in multi-stage builds.
BUILDKIT_INLINE_CACHE ?= 1
# Force plain build log.
export BUILDKIT_PROGRESS ?= plain
# Force buildkit.
export DOCKER_BUILDKIT ?= 1

CONTAINER_NAME ?= $(PROJECT_NAME)
CONTAINER_RUNNING = $(shell $(DOCKER) ps --quiet --all --filter "status=running" --filter="name=$(CONTAINER_NAME)")

# No explicit hostname means Docker Hub will be used by default.
REGISTRY_HOSTNAME ?=
REGISTRY_NAMESPACE ?=
IMAGE_NAME ?= $(PROJECT_NAME)
IMAGE_TARGET ?=
IMAGE_PARTS = $(REGISTRY_HOSTNAME) $(REGISTRY_NAMESPACE) $(IMAGE_NAME) $(subst _,/,$(IMAGE_TARGET))
IMAGE_PATH = $(call list_join,/,$(IMAGE_PARTS))
IMAGE_TAG ?= latest

# Docker image name.
IMAGE ?= $(IMAGE_PATH):$(IMAGE_TAG)

.PHONY: docker-login
docker-login: env-REGISTRY_USERNAME
docker-login: env-REGISTRY_PASSWORD
docker-login:
	@echo $(REGISTRY_PASSWORD) | $(DOCKER) login --password-stdin --username $(REGISTRY_USERNAME) $(DOCKER_REGISTRY_URL)

BUILD_ARGS ?= BUILDKIT_INLINE_CACHE=1

.PHONY: docker-build
docker-build: BUILD_OPTIONS += $(call join, ,$(addprefix --build-arg ,$(BUILD_ARGS)))
docker-build: $(if $(NO_CACHE),$(eval BUILD_OPTIONS += --no-cache))
docker-build: BUILD_OPTIONS += --target $(IMAGE_TARGET)
docker-build: BUILD_OPTIONS += --tag $(IMAGE)
docker-build: docker-pull
docker-build:
	$(DOCKER) build $(BUILD_OPTIONS) .

.PHONY: docker-push
docker-push: $(if $(CI),docker-login)
docker-push:
	$(DOCKER) push $(IMAGE)

.PHONY: docker-pull
docker-pull: $(if $(CI),docker-login)
docker-pull:
	-$(DOCKER) pull $(IMAGE)

# Ensure files checked out from SCM will be accessible inside container bind-mount.
.PHONY: fix-permissions
fix-permissions: WORKSPACE_UID = $(shell id -u)
fix-permissions: WORKSPACE_GID = $(shell id -g)
fix-permissions:
	chown -R $(WORKSPACE_UID):$(WORKSPACE_GID) .

# Set default working directory inside container.
WORKSPACE_USER ?= $(shell whoami)
WORKDIR ?= $(addprefix /,$(call list_join,/,home $(WORKSPACE_USER) $(PROJECT_NAME)))

.PHONY: docker-run
docker-run: RUN_DEPS += docker-pull
docker-run: $(if $(SKIP_BUILD),,$(eval RUN_DEPS += docker-build))
docker-run: $(if $(CI),$(eval RUN_DEPS += docker-push))
docker-run: $(if $(CI),$(eval RUN_DEPS += fix-permissions))
docker-run: $(RUN_DEPS)
docker-run: RUN_OPTIONS += --interactive
docker-run: RUN_OPTIONS += --tty
docker-run: RUN_OPTIONS += --rm
docker-run: RUN_OPTIONS += --volume $(CWD_PATH):$(WORKDIR)
docker-run: RUN_OPTIONS += --workdir $(WORKDIR)
docker-run:
	$(DOCKER) run $(RUN_OPTIONS) $(IMAGE) $(COMMAND)

.PHONY: docker-exec
docker-exec: EXEC_OPTIONS += --interactive --tty
docker-exec:
	$(DOCKER) exec $(EXEC_OPTIONS) $(CONTAINER_NAME) $(COMMAND)

.PHONY: docker-rm
docker-rm: RM_OPTIONS += --force
docker-rm:
	$(DOCKER) rm $(RM_OPTIONS) $(CONTAINER_NAME)

.PHONY: docker-command
docker-command: $(if $(CONTAINER_RUNNING),docker-exec,docker-run)

endif
