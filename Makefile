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