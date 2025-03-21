![logo](https://assets.zabbix.com/img/logo/zabbix_logo_500x131.png)


[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/zabbix/zabbix-docker/badge)](https://securityscorecards.dev/viewer/?uri=github.com/zabbix/zabbix-docker)
<a href="https://bestpractices.coreinfrastructure.org/projects/8395" style="display: inline;"><img src="https://bestpractices.coreinfrastructure.org/projects/8395/badge" style="display: inline;"></a>
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=zabbix_zabbix-docker&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=zabbix_zabbix-docker)

[![Build images (DockerHub)](https://github.com/zabbix/zabbix-docker/actions/workflows/images_build.yml/badge.svg?branch=6.0&event=push)](https://github.com/zabbix/zabbix-docker/actions/workflows/images_build.yml)
[![Build images (DockerHub, Windows)](https://github.com/zabbix/zabbix-docker/actions/workflows/images_build_windows.yml/badge.svg?branch=6.0&event=push)](https://github.com/zabbix/zabbix-docker/actions/workflows/images_build_windows.yml)

# What is Zabbix?

Zabbix is an enterprise-class open source distributed monitoring solution.

Zabbix is software that monitors numerous parameters of a network and the health and integrity of servers. Zabbix uses a flexible notification mechanism that allows users to configure e-mail based alerts for virtually any event. This allows a fast reaction to server problems. Zabbix offers excellent reporting and data visualisation features based on the stored data. This makes Zabbix ideal for capacity planning.

For more information and related downloads for Zabbix components, please visit https://hub.docker.com/u/zabbix/ and https://zabbix.com


## Zabbix Dockerfiles

This repository contains **Dockerfile** of [Zabbix](https://zabbix.com/) for [Docker](https://www.docker.com/)'s [automated build](https://registry.hub.docker.com/u/zabbix/) published to the public [Docker Hub Registry](https://registry.hub.docker.com/).

### Base Docker Image

* [alpine](https://hub.docker.com/_/alpine/)
* [centos](https://quay.io/repository/centos/centos?tab=info)
* [oracle linux](https://hub.docker.com/_/oraclelinux/) from Zabbix 5.0
* [ubuntu](https://hub.docker.com/_/ubuntu/)

> [!IMPORTANT]
> All Zabbix images based on CentOS 8 image can not be updated anymore because CentOS 8 base image is outdated on Docker Hub (base image is not updated for half year). CentOS Stream 8 and CentOS Stream 9 from quay.io is used currently.**

### Usage

There is some documentation and examples in the [official Zabbix Documentation](https://www.zabbix.com/documentation/current/manual/installation/containers)!

Please also follow usage instructions of each Zabbix component image:

* [zabbix-appliance](https://hub.docker.com/r/zabbix/zabbix-appliance/) - Zabbix appliance with built-in MySQL server, Zabbix server, Zabbix Java Gateway and Zabbix frontend based on Nginx web-server

> [!IMPORTANT]
> Zabbix Docker Appliance has been decommissioned and will not be available for 3.0.31, 4.0.19, 4.4.7, 5.0.0 and newer releases. Please use a separate Docker images for each component instead of the all-in-one solution.**

* [zabbix-agent](https://hub.docker.com/r/zabbix/zabbix-agent/) - Zabbix agent
* [zabbix-agent2](https://hub.docker.com/r/zabbix/zabbix-agent2/) - Zabbix agent 2
* [zabbix-server-mysql](https://hub.docker.com/r/zabbix/zabbix-server-mysql/) - Zabbix server with MySQL database support
* [zabbix-server-pgsql](https://hub.docker.com/r/zabbix/zabbix-server-pgsql/) - Zabbix server with PostgreSQL database support
* [zabbix-web-apache-mysql](https://hub.docker.com/r/zabbix/zabbix-web-apache-mysql/) - Zabbix web interface on Apache2 web server with MySQL database support
* [zabbix-web-apache-pgsql](https://hub.docker.com/r/zabbix/zabbix-web-apache-pgsql/) - Zabbix web interface on Apache2 web server with PostgreSQL database support
* [zabbix-web-nginx-mysql](https://hub.docker.com/r/zabbix/zabbix-web-nginx-mysql/) - Zabbix web interface on Nginx web server with MySQL database support
* [zabbix-web-nginx-pgsql](https://hub.docker.com/r/zabbix/zabbix-web-nginx-pgsql/) - Zabbix web interface on Nginx web server with PostgreSQL database support
* [zabbix-proxy-sqlite3](https://hub.docker.com/r/zabbix/zabbix-proxy-sqlite3/) - Zabbix proxy with SQLite3 database support
* [zabbix-proxy-mysql](https://hub.docker.com/r/zabbix/zabbix-proxy-mysql/) - Zabbix proxy with MySQL database support
* [zabbix-java-gateway](https://hub.docker.com/r/zabbix/zabbix-java-gateway/) - Zabbix Java Gateway
* [zabbix-web-service](https://hub.docker.com/r/zabbix/zabbix-web-service/) - Zabbix web service for performing various tasks using headless web browser (for example, reporting)
* [zabbix-snmptraps](https://hub.docker.com/r/zabbix/zabbix-snmptraps/) - Additional container image for Zabbix server and Zabbix proxy to support SNMP traps

### Docker Compose

There is provided Docker Compose files for each set of base Operating System and Database engine.

Templates support several [Compose  profiles](https://docs.docker.com/compose/profiles/). Minimal set of services is brought up by default, to start additional components e.g. Zabbix Agent use profile 'full' or 'all'. Additionally, it is possible to start only required components.

## Docker Build Command
```docker compose -f .\docker-compose_v3_ubuntu_mysql_latest.yaml up --build```
