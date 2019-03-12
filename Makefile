PWD ?= $(shell pwd)
NAME ?= vscode
TAG ?= coder-docker:latest
EMAIL ?= admin@domain.com
PUBLIC_HOSTNAME ?= $(shell curl -s http://169.254.169.254/latest/meta-data/public-hostname)
ifndef DOMAIN
DOMAIN ?= $(PUBLIC_HOSTNAME)
endif

run-coder:
	@docker run --name $(NAME) -p 8443:8443 -v "$(PWD)/root/project:/root/project" codercom/code-server code-server --allow-http

clear:
	@docker rm -f $(NAME)

build:
	@docker build -t $(TAG) .

run:
	@docker run -d --name $(NAME) \
	-e DOMAIN=$(DOMAIN) \
	-e EMAIL=$(EMAIL) \
	-v $(shell pwd)/root/.caddy:/root/.caddy \
        -v $(shell pwd)/root/project:/root/project \
        -p 80:80 -p 443:443 -p 8443:8443 $(TAG)
	@echo "open https://$(DOMAIN)"

logtail-coder:
	@docker exec -ti $(NAME) tail -f /var/log/supervisor/coder.log 

logtail-caddy:
	@docker exec -ti $(NAME) tail -f /var/log/supervisor/caddy.log
