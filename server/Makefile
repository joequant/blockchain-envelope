all:
	docker-compose build

shell:
	../../../tools/docker/shell-server.sh document-server

clean-vols:
	../../../tools/docker/rm-untagged-images.sh || echo
	../../../tools/docker/rm-stopped-containers.sh || echo
	docker volume rm document-server_user

