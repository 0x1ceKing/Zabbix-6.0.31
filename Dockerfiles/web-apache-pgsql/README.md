![logo](https://assets.zabbix.com/img/logo/zabbix_logo_500x131.png)

# What is Zabbix?

Zabbix is an enterprise-class open source distributed monitoring solution.

Zabbix is software that monitors numerous parameters of a network and the health and integrity of servers. Zabbix uses a flexible notification mechanism that allows users to configure e-mail based alerts for virtually any event. This allows a fast reaction to server problems. Zabbix offers excellent reporting and data visualisation features based on the stored data. This makes Zabbix ideal for capacity planning.

For more information and related downloads for Zabbix components, please visit https://hub.docker.com/u/zabbix/ and https://zabbix.com

# What is Zabbix web interface?

Zabbix web interface is a part of Zabbix software. It is used to manage resources under monitoring and view monitoring statistics.

# Zabbix web interface images

These are the only official Zabbix web interface Docker images. They are based on Alpine Linux v3.19, Ubuntu 22.04 (jammy), CentOS Stream 9 and Oracle Linux 9 images. The available versions of Zabbix web interface are:

    Zabbix web interface 5.0 (tags: alpine-5.0-latest, ubuntu-5.0-latest, ol-5.0-latest)
    Zabbix web interface 5.0.* (tags: alpine-5.0.*, ubuntu-5.0.*, ol-5.0.*)
    Zabbix web interface 6.0 (tags: alpine-6.0-latest, ubuntu-6.0-latest, ol-6.0-latest)
    Zabbix web interface 6.0.* (tags: alpine-6.0.*, ubuntu-6.0.*, ol-6.0.*)
    Zabbix web interface 6.4 (tags: alpine-6.4-latest, ubuntu-6.4-latest, ol-6.4-latest, alpine-latest, ubuntu-latest, ol-latest, latest)
    Zabbix web interface 6.4.* (tags: alpine-6.4.*, ubuntu-6.4.*, ol-6.4.*)
    Zabbix web interface 7.0 (tags: alpine-trunk, ubuntu-trunk, ol-trunk)

Images are updated when new releases are published. The image with ``latest`` tag is based on Alpine Linux.

Zabbix web interface available in four editions:
- Zabbix web-interface based on Apache2 web server with MySQL database support
- Zabbix web-interface based on Apache2 web server with PostgreSQL database support
- Zabbix web-interface based on Nginx web server with MySQL database support
- Zabbix web-interface based on Nginx web server with PostgreSQL database support

The image based on Apache2 web server with PostgreSQL database support.

# How to use this image

## Start `zabbix-web-apache-pgsql`

Start a Zabbix web-interface container as follows:

    docker run --name some-zabbix-web-apache-pgsql -e DB_SERVER_HOST="some-postgres-server" -e POSTGRES_USER="some-user" -e POSTGRES_PASSWORD="some-password" -e ZBX_SERVER_HOST="some-zabbix-server" -e PHP_TZ="some-timezone" -d zabbix/zabbix-web-apache-pgsql:tag

Where `some-zabbix-web-apache-pgsql` is the name you want to assign to your container, `some-postgres-server` is IP or DNS name of PostgreSQL server, `some-user` is user to connect to Zabbix database on PostgreSQL server, `some-password` is the password to connect to PostgreSQL server, `some-zabbix-server` is IP or DNS name of Zabbix server or proxy, `some-timezone` is PHP like timezone name and `tag` is the tag specifying the version you want. See the list above for relevant tags, or look at the [full list of tags](https://hub.docker.com/r/zabbix/zabbix-web-apache-pgsql/tags/).

## Linking the container to Zabbix server

    docker run --name some-zabbix-web-apache-pgsql --link some-zabbix-server:zabbix-server -e DB_SERVER_HOST="some-postgres-server" -e POSTGRES_USER="some-user" -e POSTGRES_PASSWORD="some-password" -e ZBX_SERVER_HOST="some-zabbix-server" -e PHP_TZ="some-timezone" -d zabbix/zabbix-web-apache-pgsql:tag

## Linking the container to PostgreSQL database

    docker run --name some-zabbix-web-apache-pgsql --link some-postgres-server:postgres -e DB_SERVER_HOST="some-postgres-server" -e POSTGRES_USER="some-user" -e POSTGRES_PASSWORD="some-password" -e ZBX_SERVER_HOST="some-zabbix-server" -e PHP_TZ="some-timezone" -d zabbix/zabbix-web-apache-pgsql:tag

## Container shell access and viewing Zabbix web interface logs

The `docker exec` command allows you to run commands inside a Docker container. The following command line will give you a bash shell inside your `zabbix-web-apache-pgsql` container:

```console
$ docker exec -ti some-zabbix-web-apache-pgsql /bin/bash
```

The Zabbix web interface log is available through Docker's container log:

```console
$ docker logs  some-zabbix-web-apache-pgsql
```

## Environment Variables

When you start the `zabbix-web-apache-pgsql` image, you can adjust the configuration of the Zabbix web interface by passing one or more environment variables on the `docker run` command line.

### `ZBX_SERVER_HOST`

This variable is IP or DNS name of Zabbix server. By default, value is `zabbix-server`.

### `ZBX_SERVER_PORT`

This variable is port Zabbix server listening on. By default, value is `10051`.

### `DB_SERVER_HOST`

This variable is IP or DNS name of PostgreSQL server. By default, value is 'postgres-server'

### `DB_SERVER_PORT`

This variable is port of PostgreSQL server. By default, value is '5432'.

### `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_USER_FILE`, `POSTGRES_PASSWORD_FILE`

These variables are used by Zabbix web interface to connect to Zabbix database. With the `_FILE` variables you can instead provide the path to a file which contains the user / the password instead. Without Docker Swarm or Kubernetes you also have to map the files. Those are exclusive so you can just provide one type - either `POSTGRES_USER` or `POSTGRES_USER_FILE`!

```console
docker run --name some-zabbix-web-apache-pgsql -e DB_SERVER_HOST="some-postgres-server" -v ./.POSTGRES_USER:/run/secrets/POSTGRES_USER -e POSTGRES_USER_FILE=/run/secrets/POSTGRES_USER -v ./.POSTGRES_PASSWORD:/run/secrets/POSTGRES_PASSWORD -e POSTGRES_PASSWORD_FILE=/var/run/secrets/POSTGRES_PASSWORD -e ZBX_SERVER_HOST="some-zabbix-server" -e PHP_TZ="some-timezone" -d zabbix/zabbix-web-apache-pgsql:tag
```

With Docker Swarm or Kubernetes this works with secrets. That way it is replicated in your cluster!

```console
printf "zabbix" | docker secret create POSTGRES_USER -
printf "zabbix" | docker secret create POSTGRES_PASSWORD -
docker run --name some-zabbix-web-apache-pgsql -e DB_SERVER_HOST="some-postgres-server" -e POSTGRES_USER_FILE=/run/secrets/POSTGRES_USER -e POSTGRES_PASSWORD_FILE=/run/secrets/POSTGRES_PASSWORD -e ZBX_SERVER_HOST="some-zabbix-server" -e PHP_TZ="some-timezone" -d zabbix/zabbix-web-apache-pgsql:tag
```

By default, values for `POSTGRES_USER` and `POSTGRES_PASSWORD` are `zabbix`, `zabbix`.

### `POSTGRES_DB`

The variable is Zabbix database name. By default, value is `zabbix`.

### `POSTGRES_USE_IMPLICIT_SEARCH_PATH`

In some setups, for example including [PgBouncer](https://www.pgbouncer.org), setting the `search_path` via connection parameters fails. If this variable is set to `"true"`, the image skips setting the `search_path` and trusts that the `search_path` of the Zabbix user is setup correctly in PostgreSQL database.

### `ZBX_HISTORYSTORAGEURL`

History storage HTTP[S] URL. This parameter is used for Elasticsearch setup. Available since 3.4.5.

### `ZBX_HISTORYSTORAGETYPES`

Array of value types to be sent to the history storage. An example: ['uint', 'dbl']. This parameter is used for Elasticsearch setup. Available since 3.4.5.

### `PHP_TZ`

The variable is timezone in PHP format. Full list of supported timezones are available on [`php.net`](http://php.net/manual/en/timezones.php). By default, value is 'Europe/Riga' and system timezone since Zabbix 5.2.0.

### `ZBX_SERVER_NAME`

The variable is visible Zabbix installation name in right or left top corner of the web interface.

### `DB_DOUBLE_IEEE754`

Use IEEE754 compatible value range for 64-bit Numeric (float) history values. Available since 5.0.0. Enabled by default.

### `ENABLE_WEB_ACCESS_LOG`

The variable sets the Access Log directive for Web server. By default, value corresponds to standard output.

### `HTTP_INDEX_FILE`

The variable controls default index page. By default, `index.php`.

### `EXPOSE_WEB_SERVER_INFO`

The variable allows to hide Web server and PHP versions. By default, `on`.

### `ZBX_MAXEXECUTIONTIME`

The varable is PHP ``max_execution_time`` option. By default, value is `300`.

### `ZBX_MEMORYLIMIT`

The varable is PHP ``memory_limit`` option. By default, value is `128M`.

### `ZBX_POSTMAXSIZE`

The varable is PHP ``post_max_size`` option. By default, value is `16M`.

### `ZBX_UPLOADMAXFILESIZE`

The varable is PHP ``upload_max_filesize`` option. By default, value is `2M`.

### `ZBX_MAXINPUTTIME`

The varable is PHP ``max_input_time`` option. By default, value is `300`.

### `ZBX_SESSION_NAME`

The variable is Zabbix frontend [definition](https://www.zabbix.com/documentation/6.0/manual/web_interface/definitions). String used as the name of the Zabbix frontend session cookie. By default, value is `zbx_sessionid`.

### `ZBX_DENY_GUI_ACCESS`

Enable (``true``) maintenance mode for Zabbix web-interface.

### `ZBX_GUI_ACCESS_IP_RANGE`

Array of IP addresses which are allowed for accessing to Zabbix web-interface during maintenance period.

### `ZBX_GUI_WARNING_MSG`

Information message about maintenance period for Zabbix web-interface.

### `ZBX_DB_ENCRYPTION`

The variable allows to activate encryption for connections to Zabbix database. Even if no other environment variables are specified, connections will be TLS-encrypted if `ZBX_DB_ENCRYPTION=true` specified. Available since 5.0.0. Disabled by default.

### `ZBX_DB_KEY_FILE`

The variable allows to specify the full path to a valid TLS key file. Available since 5.0.0.

### `ZBX_DB_CERT_FILE`

The variable allows to specify the full path to a valid TLS certificate file. Available since 5.0.0.

### `ZBX_DB_CA_FILE`

The variable allows to specify the full path to a valid TLS certificate authority file. Available since 5.0.0.

### `ZBX_DB_VERIFY_HOST`

The variable allows to activate host verification. Available since 5.0.0.

### `ZBX_SSO_SP_KEY`

The variable allows to specify a custom file path to the Serivce Provider (SP) private key file.

### `ZBX_SSO_SP_CERT`

The variable allows to specify a custom file path to the Serivce Provider (SP) cert file.

### `ZBX_SSO_IDP_CERT`

The variable allows to specify a custom file path to the SAML Certificate provided by the Identity Provider (ID) file.

## `ZBX_SSO_SETTINGS`

The variable allows to specify custom SSO settings in JSON format. Available since 5.0.0.

Example of YAML Mapping to Sequences

```
....
  environment:
    ZBX_SSO_SETTINGS: "{'baseurl': 'https://zabbix-docker.mydomain.com', 'use_proxy_headers': true, 'strict': false}"
    ....
....
```

### Other variables

Additionally the image allows to specify many other environment variables listed below:

```
ZBX_VAULTDBPATH= # Available since 5.2.0
ZBX_VAULTURL=https://127.0.0.1:8200 # Available since 5.2.0
VAULT_TOKEN= # Available since 5.2.0

Allowed PHP-FPM configuration options:
PHP_FPM_PM=dynamic
PHP_FPM_PM_MAX_CHILDREN=50
PHP_FPM_PM_START_SERVERS=5
PHP_FPM_PM_MIN_SPARE_SERVERS=5
PHP_FPM_PM_MAX_SPARE_SERVERS=35
PHP_FPM_PM_MAX_REQUESTS=0
```

## Allowed volumes for the Zabbix web interface container

### ``/etc/ssl/apache2``

The volume allows to enable HTTPS for the Zabbix web interface. The volume must contains two files ``ssl.crt`` and ``ssl.key`` prepared for Apache2 SSL connections.

Please follow official Apache2 [documentation](https://httpd.apache.org/docs/2.4/ssl/ssl_howto.html) to get more details about how to create certificate files.

### ``/etc/zabbix/web/certs``

The volume allows to use custom certificates for SAML authentification. The volume must contains three files ``sp.key``, ``sp.crt`` and ``idp.crt``. Available since 5.0.0.

# The image variants

The `zabbix-web-apache-pgsql` images come in many flavors, each designed for a specific use case.

## `zabbix-web-apache-pgsql:alpine-<version>`

This image is based on the popular [Alpine Linux project](http://alpinelinux.org), available in [the `alpine` official image](https://hub.docker.com/_/alpine). Alpine Linux is much smaller than most distribution base images (~5MB), and thus leads to much slimmer images in general.

This variant is highly recommended when final image size being as small as possible is desired. The main caveat to note is that it does use [musl libc](http://www.musl-libc.org) instead of [glibc and friends](http://www.etalabs.net/compare_libcs.html), so certain software might run into issues depending on the depth of their libc requirements. However, most software doesn't have an issue with this, so this variant is usually a very safe choice. See [this Hacker News comment thread](https://news.ycombinator.com/item?id=10782897) for more discussion of the issues that might arise and some pro/con comparisons of using Alpine-based images.

To minimize image size, it's uncommon for additional related tools (such as `git` or `bash`) to be included in Alpine-based images. Using this image as a base, add the things you need in your own Dockerfile (see the [`alpine` image description](https://hub.docker.com/_/alpine/) for examples of how to install packages if you are unfamiliar).

## `zabbix-web-apache-pgsql:ubuntu-<version>`

This is the defacto image. If you are unsure about what your needs are, you probably want to use this one. It is designed to be used both as a throw away container (mount your source code and start the container to start your app), as well as the base to build other images off of.

## `zabbix-web-apache-pgsql:ol-<version>`

Oracle Linux is an open-source operating system available under the GNU General Public License (GPLv2). Suitable for general purpose or Oracle workloads, it benefits from rigorous testing of more than 128,000 hours per day with real-world workloads and includes unique innovations such as Ksplice for zero-downtime kernel patching, DTrace for real-time diagnostics, the powerful Btrfs file system, and more.

# Supported Docker versions

This image is officially supported on Docker version 1.12.0.

Support for older versions (down to 1.6) is provided on a best-effort basis.

Please see [the Docker installation documentation](https://docs.docker.com/installation/) for details on how to upgrade your Docker daemon.

# User Feedback

## Documentation

Documentation for this image is stored in the [`web-apache-pgsql/` directory](https://github.com/zabbix/zabbix-docker/tree/6.0/Dockerfiles/web-apache-pgsql) of the [`zabbix/zabbix-docker` GitHub repo](https://github.com/zabbix/zabbix-docker/). Be sure to familiarize yourself with the [repository's `README.md` file](https://github.com/zabbix/zabbix-docker/blob/6.0/README.md) before attempting a pull request.

## Issues

If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/zabbix/zabbix-docker/issues).

### Known issues

## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/zabbix/zabbix-docker/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.

## License

Starting from Zabbix version 7.0, all subsequent Zabbix versions will be released under the GNU Affero General Public License version 3 (AGPLv3).
You can modify the relevant version and propagate such modified version under the terms of the AGPLv3 as published by the Free Software Foundation.
For additional details, including answers to common questions about the AGPLv3, see the generic FAQ from the [Free Software Foundation](http://www.fsf.org/licenses/gpl-faq.html).

Zabbix is Open Source Software, however, if you use Zabbix in a commercial context we kindly ask you to support the development of Zabbix by purchasing some level of technical support.
All previous Zabbix software versions up to 6.4 are released under the GNU General Public License version 2 (GPLv2). The formal terms of the GPLv2 and AGPLv3 can be found at http://www.fsf.org/licenses/.
