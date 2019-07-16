#
# Use the exported builder image
#
FROM builder:postgresql-amd64-centos

#
# Build Time Arguments
#
ARG POSTGRESQL_NAME
ARG POSTGRESQL_ROOT
ARG POSTGRESQL_VERSION
ARG POSTGRESQL_SVC_NAME
ARG POSTGRESQL_SVC_UID

#
# Do some bookeeping for the repository and openshift
#
#
# It is deprecated but guess what...There are a lot of tools that still use it
#
MAINTAINER ignidis(at)cybearth(dot)net (https://github.com/ignidis/postgresql-docker)

#
# And this is for those new tools
#
LABEL summary="Platform for running ${POSTGRESQL_NAME}-${POSTGRESQL_VERSION} or building ${POSTGRESQL_NAME}-based applications" \
      description="${POSTGRESQL_NAME} is the most advanced open source Object Relational Database Management System ORDMS. The container image provides a containerized packaging of the ${POSTGRESQL_NAME}-${POSTGRESQL_VERSION} daemon. The image can be used as a base image for other applications based on the ${POSTGRESQL_NAME} ORDBMS." \
      io.k8s.description="${POSTGRESQL_NAME} is the most advanced open source Object Relational Database Management System ORDMS. The container image provides a containerized packaging of the ${POSTGRESQL_NAME}-${POSTGRESQL_VERSION} daemon. The image can be used as a base image for other applications based on the ${POSTGRESQL_NAME} ORDBMS." \
      io.k8s.display-POSTGRESQL_NAME="POSTGRESQL-${POSTGRESQL_VERSION}" \
      io.openshift.expose-services="5432" \
      io.openshift.tags="builder,${POSTGRESQL_NAME},${POSTGRESQL_NAME}-${POSTGRESQL_VERSION}" \
      name="${POSTGRESQL_NAME}" \
      version="${POSTGRESQL_VERSION}-amd64-centos" \
      maintainer="ignidis(at)cybearth(dot)net" \
      help="For more information visit https://github.com/ignidis/postgresql-docker"

#
# we must ensure the postgresql commands are found
#
ENV PATH=${POSTGRESQL_ROOT}/bin:/usr/pgsql-${POSTGRESQL_VERSION}/bin:${PATH} \
    PG_VERSION=${POSTGRESQL_VERSION} \
    PGDATA=/var/lib/pgsql/${POSTGRESQL_VERSION}/data \
    PG_OPTS=""

#
# Publish the standard postgresql remote port
#
EXPOSE 5432
VOLUME ["/var/lib/pgsql"]

STOPSIGNAL SIGTERM

USER ${POSTGRESQL_SVC_UID}
WORKDIR ${POSTGRESQL_ROOT}

ENTRYPOINT [ "bin/init" ]
CMD ["postgres"]
