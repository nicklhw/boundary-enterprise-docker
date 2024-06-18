TF_INFRA_SRC_DIR ?= ./terraform
DOCKER_COMPOSE_DIR ?= ./docker-compose
DOCKER_COMPOSE_FILE ?= $(DOCKER_COMPOSE_DIR)/docker-compose.yml

.PHONY: all
all: clean up

.PHONY: up
up:
	docker-compose -f $(DOCKER_COMPOSE_FILE) up --detach

.PHONY: clean
clean:
	docker-compose -f $(DOCKER_COMPOSE_FILE) down --remove-orphans

.PHONY: tf-plan
tf-plan:
	terraform -chdir=$(TF_INFRA_SRC_DIR) init -upgrade
	terraform -chdir=$(TF_INFRA_SRC_DIR) plan

.PHONY: tf-apply
tf-apply:
	terraform -chdir=$(TF_INFRA_SRC_DIR) init -upgrade
	terraform -chdir=$(TF_INFRA_SRC_DIR) apply --auto-approve

.PHONY: tf-destroy
tf-destroy:
	terraform -chdir=$(TF_INFRA_SRC_DIR) destroy --auto-approve

.PHONY: tf-fmt
tf-fmt:
	terraform -chdir=$(TF_INFRA_SRC_DIR) fmt -recursive