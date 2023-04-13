DOMAIN_USER = lrosa-do
VOLUME = data
WORDPRESS_VOLUME=/home/${DOMAIN_USER}/${VOLUME}/wordpress
MARIADB_VOLUME=/home/${DOMAIN_USER}/${VOLUME}/mariadb
ALL_VOLUMES = $(shell docker volume ls -q)
ALL_IMAGES  = $(shell docker images ls -q)
ALL_CONTAINERS  = $(shell docker container ls -q)

all: create_dirs
	@docker compose -f ./srcs/docker-compose.yml up -d

#
up:
	@docker compose -f ./srcs/docker-compose.yml up -d

down:
	@docker compose -f ./srcs/docker-compose.yml down

re: create_dirs
	@docker compose -f srcs/docker-compose.yml build --no-cache

try: 
	@docker compose -f srcs/docker-compose.yml up -d --build 


ssl:
	@if [ ! -f srcs/requirements/nginx/tools/nginx.key ] && [ ! -f srcs/requirements/nginx/tools/nginx.crt ]; then \
			mkdir -p srcs/requirements/nginx/tools/; \
		openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout nginx.key -out nginx.crt -subj "/C=PT/ST=Barreiro/L=Lisboa/CN=lrosa-do.42.fr"; \
		mv nginx.key srcs/requirements/nginx/tools/; \
		mv nginx.crt srcs/requirements/nginx/tools/; \
	fi

create_dirs:ssl
	@sudo mkdir -pv /home/${DOMAIN_USER}/${VOLUME}
	@sudo mkdir -pv $(MARIADB_VOLUME)
	@sudo mkdir -pv $(WORDPRESS_VOLUME)

clean-brave:
	@echo "Limpando o cache do Brave"
	@rm -rf ~/.config/BraveSoftware/Brave-Browser/Default/*	

clean:down
	@docker image prune -f

status:
	docker stop $(docker ps -qa) 
	docker rm $(docker ps -qa)
	docker rmi -f $(docker images -qa)
	docker volume rm $(docker volume ls -q)
	docker network rm $(docker network ls -q)


fclean:  clean
	@docker system prune -a --force
ifneq ($(ALL_VOLUMES),)
	@docker volume rm $(ALL_VOLUMES)
endif
	@docker system prune -a --volumes --force
	@sudo rm -rf /home/${DOMAIN_USER}/${VOLUME}/*
	@sudo rm -rf /home/${DOMAIN_USER}/${VOLUME}


.PHONY: all re down clean try fclean ssl