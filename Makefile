all:	build run

build:
	docker-compose build

run:
	docker-compose run loppen_backup
#	docker-compose run -d loppen_backup

down:
	docker-compose down
