build:
	docker-compose build

start:
	docker-compose up document-server &

stop:
	docker-compose stop document-server

shell:
	..//tools/docker/shell-server.sh document-server

clean-vols:
	docker-compose stop document-server || echo
	../tools/docker/rm-stopped-containers.sh || echo
	../tools/docker/rm-untagged-images.sh || echo
	docker volume rm document-server_user || echo

