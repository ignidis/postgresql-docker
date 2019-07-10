#!/bin/bash
#
# docker build image
# Usage:
#        [sudo] build.sh <postgresql-version>
#
# Must run as superuser, either you are root or must sudo 
#
docker build --build-arg POSTGRESQL_NAME="POSTGRESQL" --build-arg POSTGRESQL_ROOT="/opt/postgresql" --build-arg POSTGRESQL_VERSION="$1" --build-arg POSTGRESQL_SVC_NAME="postgres" --build-arg POSTGRESQL_SVC_UID="9002" -t postgresql:"$1"-amd64-centos .
