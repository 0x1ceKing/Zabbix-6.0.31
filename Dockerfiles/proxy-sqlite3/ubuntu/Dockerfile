# syntax=docker/dockerfile:1
ARG MAJOR_VERSION=6.0
ARG ZBX_VERSION=${MAJOR_VERSION}.31
ARG BUILD_BASE_IMAGE=zabbix-build-sqlite3:ubuntu-${ZBX_VERSION}

FROM ${BUILD_BASE_IMAGE} AS builder

FROM ubuntu:jammy

ARG MAJOR_VERSION
ARG ZBX_VERSION
ARG ZBX_SOURCES=https://git.zabbix.com/scm/zbx/zabbix.git

ENV TERM=xterm \
    ZBX_VERSION=${ZBX_VERSION} ZBX_SOURCES=${ZBX_SOURCES} \
    MIBDIRS=/var/lib/mibs/ietf:/var/lib/mibs/iana:/usr/share/snmp/mibs:/var/lib/zabbix/mibs MIBS=+ALL \
    NMAP_PRIVILEGED=""

LABEL org.opencontainers.image.authors="Alexey Pustovalov <alexey.pustovalov@zabbix.com>" \
      org.opencontainers.image.description="Zabbix proxy with SQLite3 database support" \
      org.opencontainers.image.documentation="https://www.zabbix.com/documentation/${MAJOR_VERSION}/manual/installation/containers" \
      org.opencontainers.image.licenses="GPL v2.0" \
      org.opencontainers.image.source="${ZBX_SOURCES}" \
      org.opencontainers.image.title="Zabbix proxy (SQLite3)" \
      org.opencontainers.image.url="https://zabbix.com/" \
      org.opencontainers.image.vendor="Zabbix SIA" \
      org.opencontainers.image.version="${ZBX_VERSION}"

STOPSIGNAL SIGTERM

COPY --from=builder ["/tmp/zabbix-${ZBX_VERSION}-output/proxy/sbin/zabbix_proxy", "/usr/sbin/zabbix_proxy"]
COPY --from=builder ["/tmp/zabbix-${ZBX_VERSION}-output/proxy/conf/", "/etc/zabbix/"]
COPY --from=builder ["/tmp/zabbix-${ZBX_VERSION}-output/general/bin/", "/usr/bin/"]

RUN --mount=type=cache,target=/var/lib/apt/,sharing=locked \
    set -eux && \
    echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d && \
    INSTALL_PKGS="bash \
            tini \
            tzdata \
            traceroute \
            nmap \
            ca-certificates \
            fping \
            libcurl4 \
            libevent-2.1 \
            libopenipmi0 \
            libpcre2-8-0 \
            libsnmp40 \
            libsqlite3-0 \
            libssh-4 \
            libssl3 \
            libxml2 \
            snmp-mibs-downloader \
            unixodbc \
            zlib1g" && \
    apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y \
            --no-install-recommends install \
        ${INSTALL_PKGS} && \
    groupadd \
            --system \
            --gid 1995 \
        zabbix && \
    useradd \
            --system \
            --comment "Zabbix monitoring system" \
            -g zabbix \
            --uid 1997 \
            --shell /sbin/nologin \
            --home-dir /var/lib/zabbix/ \
        zabbix && \
    chgrp zabbix /usr/bin/nmap && \
    setcap cap_net_raw+eip /usr/bin/nmap && \
    mkdir -p /etc/zabbix && \
    mkdir -p /var/lib/zabbix && \
    mkdir -p /var/lib/zabbix/db_data && \
    mkdir -p /var/lib/zabbix/enc && \
    mkdir -p /usr/lib/zabbix/externalscripts && \
    mkdir -p /var/lib/zabbix/mibs && \
    mkdir -p /var/lib/zabbix/modules && \
    mkdir -p /var/lib/zabbix/snmptraps && \
    mkdir -p /var/lib/zabbix/ssh_keys && \
    mkdir -p /var/lib/zabbix/ssl && \
    mkdir -p /var/lib/zabbix/ssl/certs && \
    mkdir -p /var/lib/zabbix/ssl/keys && \
    mkdir -p /var/lib/zabbix/ssl/ssl_ca && \
    chown --quiet -R zabbix:root /etc/zabbix/ /var/lib/zabbix/ && \
    chgrp -R 0 /etc/zabbix/ /var/lib/zabbix/ && \
    chmod -R g=u /etc/zabbix/ /var/lib/zabbix/ && \
    apt-get -y autoremove

EXPOSE 10051/TCP

WORKDIR /var/lib/zabbix

VOLUME ["/var/lib/zabbix/snmptraps"]

COPY ["docker-entrypoint.sh", "/usr/bin/"]

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/bin/docker-entrypoint.sh"]

USER 1997

CMD ["/usr/sbin/zabbix_proxy", "--foreground", "-c", "/etc/zabbix/zabbix_proxy.conf"]
