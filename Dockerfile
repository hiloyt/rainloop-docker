FROM alpine:3.11

LABEL description "Rainloop is a simple, modern & fast web-based client" \
ENV UID=991 GID=991 UPLOAD_MAX_SIZE=25M LOG_TO_STDOUT=false MEMORY_LIMIT=128M

RUN echo "@community https://nl.alpinelinux.org/alpine/v3.11/community" >> /etc/apk/repositories \
 && apk -U upgrade \
 && apk add -t build-dependencies \
    openssl \
    wget \
 && apk add \
    ca-certificates \
    nginx \
    s6 \
    su-exec \
    php7-fpm@community \
    php7-curl@community \
    php7-iconv@community \
    php7-xml@community \
    php7-dom@community \
    php7-openssl@community \
    php7-json@community \
    php7-zlib@community \
    php7-pdo_pgsql@community \
    php7-pdo_mysql@community \
    php7-pdo_sqlite@community \
    php7-sqlite3@community \
    php7-ldap@community \
    php7-simplexml@community \
 && cd /tmp \
 && wget -q https://www.rainloop.net/repository/webmail/rainloop-community-latest.zip \
 && mkdir /rainloop && unzip -q /tmp/rainloop-community-latest.zip -d /rainloop \
 && find /rainloop -type d -exec chmod 755 {} \; \
 && find /rainloop -type f -exec chmod 644 {} \; \
 && apk del build-dependencies \
 && rm -rf /tmp/* /var/cache/apk/* /root/.gnupg

COPY rootfs /
RUN chmod +x /usr/local/bin/run.sh /services/*/run /services/.s6-svscan/*
VOLUME /rainloop/data
EXPOSE 8888
CMD ["run.sh"]
