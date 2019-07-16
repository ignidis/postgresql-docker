#!/bin/bash
#
# docker build image
# Usage:
#        [sudo] build.sh <postgresql-version> <registry> <registry-user> <registry-pwd> <project>
#
# Must run as superuser, either you are root or must sudo 
#
docker build --build-arg POSTGRESQL_NAME="POSTGRESQL" --build-arg POSTGRESQL_ROOT="/opt/postgresql" --build-arg POSTGRESQL_VERSION="$1" --build-arg POSTGRESQL_SVC_NAME="postgres" --build-arg POSTGRESQL_SVC_UID="9002" --rm -t builder:ml-postgresql-amd64-centos --file ./Builderfile . && \
docker run --rm -it -d --name builder-postgresql-amd64-centos builder:ml-postgresql-amd64-centos bash && \
docker export builder-postgresql-amd64-centos | docker import - builder:postgresql-amd64-centos && \
docker kill builder-postgresql-amd64-centos && \
docker build --build-arg POSTGRESQL_NAME="POSTGRESQL" --build-arg POSTGRESQL_ROOT="/opt/postgresql" --build-arg POSTGRESQL_VERSION="$1" --build-arg POSTGRESQL_SVC_NAME="postgres" --build-arg POSTGRESQL_SVC_UID="9002" --rm -t "$2"/"$5"/postgresql:"$1"-amd64-centos . && \
docker rmi builder:ml-postgresql-amd64-centos builder:postgresql-amd64-centos && \
docker login -p "$4" -u "$3" "$2" && \
docker push "$2"/"$5"/postgresql:"$1"-amd64-centos && \
docker rmi "$2"/"$5"/postgresql:"$1"-amd64-centos