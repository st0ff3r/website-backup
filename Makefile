all:	build run

build:
	docker-compose build

run:
#	docker-compose run website_backup
	docker-compose run -d website_backup

down:
	docker-compose stop
	docker-compose down
