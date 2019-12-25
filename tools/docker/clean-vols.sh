#!/bin/bash
set -e 
docker-compose stop $1 || echo
../tools/docker/rm-stopped-containers.sh || echo
../tools/docker/rm-untagged-images.sh || echo
docker volume rm $2 || echo
