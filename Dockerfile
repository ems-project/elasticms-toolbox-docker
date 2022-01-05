ARG VERSION_ARG
ARG ELASTICDUMP_VERSION_ARG
ARG CERTINFO_VERSION_ARG
ARG WEB2ELASTICMS_VERSION_ARG

FROM docker.io/elasticms/base-php-cli-dev:7.4 as builder

ARG RELEASE_ARG=""
ARG BUILD_DATE_ARG=""
ARG VCS_REF_ARG=""

USER root

RUN echo "Install required build tools ..." \
    && echo "Install Go ..." \
    && apk add --update --no-cache go make

USER 1001

#
# BUILD WebToElasticms
#
ENV WEB2ELASTICMS_VERSION=${WEB2ELASTICMS_VERSION_ARG:-master} \
    WEB2ELASTICMS_DOWNLOAD_URL="https://github.com/ems-project/WebToElasticms/archive/refs/heads/master.zip" 

RUN echo "Download and build WebToElasticms ..." \
    && cd /opt/src \
    && curl -sSfL ${WEB2ELASTICMS_DOWNLOAD_URL} | unzip - \
    && COMPOSER_MEMORY_LIMIT=-1 composer -vvvv install --no-interaction --no-suggest --no-scripts --working-dir /opt/src/WebToElasticms-master -o 

#
# BUILD Elasticdump
#
ENV ELASTICDUMP_VERSION=${ELASTICDUMP_VERSION_ARG:-6.76.0}

RUN echo "Download and build Elasticdump ..." \
    && npm set progress=false \
    && npm config set depth 0 \
    && npm install --prefix /opt/elasticdump elasticdump@${ELASTICDUMP_VERSION} --only=production -g

#
# BUILD Certinfo
#
ENV CERTINFO_VERSION=${CERTINFO_VERSION_ARG:-1.0.6} \
    CERTINFO_DOWNLOAD_URL="https://github.com/pete911/certinfo/archive/refs/tags" 

RUN echo "Download and build Certinfo ..." \
    && mkdir /opt/certinfo \
    && curl -sSfL ${CERTINFO_DOWNLOAD_URL}/v${CERTINFO_VERSION}.tar.gz | \
       tar -xzC /opt/certinfo --strip 1 \
    && cd /opt/certinfo \
    && make build

FROM docker.io/elasticms/base-php-cli:7.4

ARG RELEASE_ARG
ARG BUILD_DATE_ARG
ARG VCS_REF_ARG

ENV NODE_ENV production

LABEL eu.elasticms.toolbox.build-date=$BUILD_DATE_ARG \
      eu.elasticms.toolbox.name="" \
      eu.elasticms.toolbox.description="" \
      eu.elasticms.toolbox.url="https://hub.docker.com/repository/docker/elasticms/toolbox" \
      eu.elasticms.toolbox.vcs-ref=$VCS_REF_ARG \
      eu.elasticms.toolbox.vcs-url="https://github.com/ems-project/elasticms-toolbox-docker" \
      eu.elasticms.toolbox.vendor="sebastian.molle@gmail.com" \
      eu.elasticms.toolbox.version="$VERSION_ARG" \
      eu.elasticms.toolbox.release="$RELEASE_ARG" \
      eu.elasticms.toolbox.schema-version="1.0" 

USER root

RUN echo "Install required runtime ..." \
    && echo "Install NodeJS ..." \
    && apk add --update --no-cache nodejs 

#
# INSTALL WebToElasticms
#
COPY --from=builder /opt/src/WebToElasticms-master /opt/src

#
# INSTALL Elasticdump
#
COPY --from=builder /opt/elasticdump /usr/local

#
# INSTALL certinfo
#
COPY --from=builder /opt/certinfo/certinfo /usr/local/bin

WORKDIR /opt/src

USER 1001
