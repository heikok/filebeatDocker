FROM alpine:3.4

MAINTAINER Heiko Kundlacz <heiko.kundlacz@gmail.com>

LABEL name="filebeat" version=$VERSION

ENV PATH $PATH:/opt/filebeat

ARG VERSION=1.2.3
ARG GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download"
ARG GLIBC_PACKAGE_VERSION="2.23-r3"
ARG GLIBC_BASE_PACKAGE_FILENAME="glibc-${GLIBC_PACKAGE_VERSION}.apk"
ARG GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-${GLIBC_PACKAGE_VERSION}.apk"
ARG GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-${GLIBC_PACKAGE_VERSION}.apk" 

COPY ${GLIBC_BASE_PACKAGE_FILENAME} /opt/ 
COPY ${GLIBC_BIN_PACKAGE_FILENAME} /opt/ 
COPY ${GLIBC_I18N_PACKAGE_FILENAME} /opt/ 

RUN apk add --no-cache wget ca-certificates bash \
    && apk add --allow-untrusted --no-cache /opt/${GLIBC_BASE_PACKAGE_FILENAME} /opt/${GLIBC_BIN_PACKAGE_FILENAME} /opt/${GLIBC_I18N_PACKAGE_FILENAME} \
    && wget -q -O - --no-check-certificate https://download.elastic.co/beats/filebeat/filebeat-${VERSION}-x86_64.tar.gz | tar xzf - -C /opt \
    && mkdir /etc/filebeat \
    && mv /opt/filebeat-$VERSION-x86_64 /opt/filebeat \
    && cp /opt/filebeat/filebeat.yml /etc/filebeat/filebeat.yml \
    && rm /opt/${GLIBC_BASE_PACKAGE_FILENAME} /opt/${GLIBC_BIN_PACKAGE_FILENAME} /opt/${GLIBC_I18N_PACKAGE_FILENAME} 

CMD ["filebeat","-e","-v","-c","/etc/filebeat/filebeat.yml"]
