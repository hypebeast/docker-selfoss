all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make build       - build the php5-fpm image"
	@echo "   3. make demo        - start gogs with sqlite database"
	@echo "   4. make stop        - stop gogs"
	@echo "   5. make logs        - view logs"
	@echo "   6. make purge       - stop and remove the container"
	@echo "   7. make shell       - run an interactive shell"
	@echo "   8. make debug       - connect to the running demo container and run an interactive shell"
	@echo "   9. make release     - make a release image"

build:
	@docker build --tag=${USER}/selfoss .

release: build
	@docker build --tag=${USER}/selfoss:$(shell cat VERSION) .

demo:
	@echo "Starting selfoss-demo..."
	@docker run --name=selfoss-demo -p 3010:80 -d \
		${USER}/selfoss:latest >/dev/null
	@echo "Please be patient. This could take a while..."
	@echo "gogs will be available at http://localhost:10030"
	@echo "Type 'make logs' for the logs"

stop:
	@echo "Stopping selfoss..."
	@docker stop selfoss-demo >/dev/null

purge: stop
	@echo "Removing stopped container..."
	@docker rm selfoss-demo >/dev/null

shell:
	@echo "Running interactive shell"
	@docker run -i -t ${USER}/selfoss:latest /bin/bash

debug:
	CONTAINER_ID:=(shell docker ps | grep 'selfoss-demo' | awk '{ print $$1; }')
	@docker exec -it $(CONTAINER_ID) /bin/bash

logs:
	@docker logs -f selfoss-demo

