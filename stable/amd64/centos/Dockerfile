#
# Use the unmodified centos image
#
FROM centos:7

#
# Build Time Arguments
#
ARG POSTGRESQL_NAME
ARG POSTGRESQL_ROOT
ARG POSTGRESQL_VERSION
ARG POSTGRESQL_SVC_NAME
ARG POSTGRESQL_SVC_UID

#
# Install the POSTGRESQL official repository and update the image packages
#
RUN yum -y update && yum -y upgrade; \
#
#
# Add POSTGRESQL official repositories
#
    yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm \
#
#
# Add EPEL official repositories for required dependencies
#
    yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; \
#
#
# Install POSTGRESQL and any additional support packages
#
    yum install -y --setopt=tsflags=nodocs \
        postgresql${POSTGRESQL_VERSION}-server \
        postgresql${POSTGRESQL_VERSION}-plpython \
        postgresql${POSTGRESQL_VERSION}-contrib \
    ; \
#
#
# Do some cleanup to reduce the image load
#
    yum clean all -y; \
    rm -rf /var/cache/yum; \
    rm -rf /var/temp; \
#
#
# Create or modify postgres group and service account to use the uid,guid we desire
#
    if id -u ${POSTGRESQL_SVC_NAME} >/dev/null 2>&1; then  \
        groupmod -g ${POSTGRESQL_SVC_UID} ${POSTGRESQL_SVC_NAME}; \ 
        usermod  -u ${POSTGRESQL_SVC_UID} -g ${POSTGRESQL_SVC_NAME} -G root ${POSTGRESQL_SVC_NAME}; \
    fi; 
#
#
# Setup runtime variables
#
#ENV PATH=/usr/pgsql-${POSTGRESQL_VERSION}/bin:${PATH};

#
# Copy container startup script, certbot wrapper and certificate renewal scheduler
#
COPY bin/ ${POSTGRESQL_ROOT}/bin/
COPY etc/ /etc/pgsql/

#
# Ammend the access rights to the configuration areas
# This will only work if the runtime user is member of the root group - this is the case with openshift
# In non openshift environment we should do the configuration volume initialization before attaching or make the executing user member of the root group
#
RUN rm -rf /var/log/*\
    ; \
#
#
# add permisions to the application init scripts and sql server directories
# in addition allow the non root user to insert the anonymous openshift user if we want to use it
# and ensure we can read the config files
#
    chown -R ${POSTGRESQL_SVC_UID}:${POSTGRESQL_SVC_UID} /var/lib/pgsql/; \
    chmod -R u+x ${POSTGRESQL_ROOT}/bin && \
    chmod -R g=u ${POSTGRESQL_ROOT} /var/lib/pgsql/ /etc/passwd; \
#
# Docker COPY does not preserve ownership thus we use tar to store a copy of the postgres work directory
# During volume INIT tar will restore the original schema ownership and permissions.
# It is very important that the target directory is empty.
#
    cd /var/lib/pgsql; \
    tar -cpf ${POSTGRESQL_ROOT}/var-lib-pgsql.tar . ; \
    rm -rf * \
    ; 
#
# Compress the images
#
FROM scratch
COPY --from=0 / /

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
