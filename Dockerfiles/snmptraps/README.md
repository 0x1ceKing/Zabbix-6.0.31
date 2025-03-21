![logo](https://assets.zabbix.com/img/logo/zabbix_logo_500x131.png)

# What is Zabbix?

Zabbix is an enterprise-class open source distributed monitoring solution.

Zabbix is software that monitors numerous parameters of a network and the health and integrity of servers. Zabbix uses a flexible notification mechanism that allows users to configure e-mail based alerts for virtually any event. This allows a fast reaction to server problems. Zabbix offers excellent reporting and data visualisation features based on the stored data. This makes Zabbix ideal for capacity planning.

For more information and related downloads for Zabbix components, please visit https://hub.docker.com/u/zabbix/ and https://zabbix.com

# What is the image?

The image is used to receive SNMP traps, store them to a log file and provide access to Zabbix to collected SNMP trap messsages.

# Zabbix snmptraps images

These are the only official Zabbix snmptraps Docker images. They are based on Alpine Linux v3.19, Ubuntu 22.04 (jammy), CentOS Stream 9 and Oracle Linux 9 images. The available versions of Zabbix snmptraps are:

    Zabbix snmptraps 5.0 (tags: alpine-5.0-latest, ubuntu-5.0-latest, ol-5.0-latest)
    Zabbix snmptraps 5.0.* (tags: alpine-5.0.*, ubuntu-5.0.*, ol-5.0.*)
    Zabbix snmptraps 6.0 (tags: alpine-6.0-latest, ubuntu-6.0-latest, ol-6.0-latest)
    Zabbix snmptraps 6.0.* (tags: alpine-6.0.*, ubuntu-6.0.*, ol-6.0.*)
    Zabbix snmptraps 6.4 (tags: alpine-6.4-latest, ubuntu-6.4-latest, ol-6.4-latest, alpine-latest, ubuntu-latest, ol-latest, latest)
    Zabbix snmptraps 6.4.* (tags: alpine-6.4.*, ubuntu-6.4.*, ol-6.4.*)
    Zabbix snmptraps 7.0 (tags: alpine-trunk, ubuntu-trunk, ol-trunk)

Images are updated when new releases are published.

# How to use this image

## Start `zabbix-snmptraps`

Start a Zabbix snmptraps container as follows:

    docker run --name some-zabbix-snmptraps -p 162:1162/udp -d zabbix/zabbix-snmptraps:tag

Where `some-zabbix-snmptraps` is the name you want to assign to your container and `tag` is the tag specifying the version you want. See the list above for relevant tags, or look at the [full list of tags](https://hub.docker.com/r/zabbix/zabbix-snmptraps/tags/).

## Linking Zabbix server or Zabbix proxy with the container

    docker run --name some-zabbix-server --link some-zabbix-snmptraps:zabbix-snmptraps --volumes-from some-zabbix-snmptraps -d zabbix/zabbix-server:tag

## Container shell access and viewing Zabbix snmptraps logs

The `docker exec` command allows you to run commands inside a Docker container. The following command line will give you a bash shell inside your `zabbix-snmptraps` container:

```console
$ docker exec -ti some-zabbix-snmptraps /bin/bash
```

The Zabbix snmptraps log is available through Docker's container log:

```console
$ docker logs  some-zabbix-snmptraps
```

## Environment Variables

When you start the `zabbix-snmptraps` image, you can adjust the configuration by passing one or more environment variables on the `docker run` command line.

### `ZBX_SNMP_TRAP_DATE_FORMAT`

This variable is represent date and time format in the output `snmptraps.log` file. By default, value is `+%Y%m%d.%H%M%S`. Please, refer to `date` command man for more details about date and time format.

### `ZBX_SNMP_TRAP_FORMAT`

This variable is SNMP trap format in the output `snmptraps.log` file. By default, value is `\n`, in this case each new variable is placed on new line.

### `ZBX_SNMP_TRAP_USE_DNS`

This variable manages source network address representation. It can be IP address or DNS of SNMP trap sender. The variable works only when container command is modified and "-n" command argument is removed from argument list. By default, value is `false`.


## Allowed volumes for the Zabbix snmptraps container

### ``/var/lib/zabbix/snmptraps``

The volume contains log file ``snmptraps.log`` named with received SNMP traps.

### ``/var/lib/zabbix/mibs``

The volume allows to add new MIB files. It does not support subdirectories, all MIBs must be placed to ``/var/lib/zabbix/mibs``.

# The image variants

The `zabbix-snmptraps` images come in many flavors, each designed for a specific use case.

## `zabbix-snmptraps:alpine-<version>`

This image is based on the popular [Alpine Linux project](http://alpinelinux.org), available in [the `alpine` official image](https://hub.docker.com/_/alpine). Alpine Linux is much smaller than most distribution base images (~5MB), and thus leads to much slimmer images in general.

This variant is highly recommended when final image size being as small as possible is desired. The main caveat to note is that it does use [musl libc](http://www.musl-libc.org) instead of [glibc and friends](http://www.etalabs.net/compare_libcs.html), so certain software might run into issues depending on the depth of their libc requirements. However, most software doesn't have an issue with this, so this variant is usually a very safe choice. See [this Hacker News comment thread](https://news.ycombinator.com/item?id=10782897) for more discussion of the issues that might arise and some pro/con comparisons of using Alpine-based images.

To minimize image size, it's uncommon for additional related tools (such as `git` or `bash`) to be included in Alpine-based images. Using this image as a base, add the things you need in your own Dockerfile (see the [`alpine` image description](https://hub.docker.com/_/alpine/) for examples of how to install packages if you are unfamiliar).

## `zabbix-snmptraps:ubuntu-<version>`

This is the defacto image. If you are unsure about what your needs are, you probably want to use this one. It is designed to be used both as a throw away container (mount your source code and start the container to start your app), as well as the base to build other images off of.

## `zabbix-snmptraps:ol-<version>`

Oracle Linux is an open-source operating system available under the GNU General Public License (GPLv2). Suitable for general purpose or Oracle workloads, it benefits from rigorous testing of more than 128,000 hours per day with real-world workloads and includes unique innovations such as Ksplice for zero-downtime kernel patching, DTrace for real-time diagnostics, the powerful Btrfs file system, and more.

# Supported Docker versions

This image is officially supported on Docker version 1.12.0.

Support for older versions (down to 1.6) is provided on a best-effort basis.

Please see [the Docker installation documentation](https://docs.docker.com/installation/) for details on how to upgrade your Docker daemon.

# User Feedback

## Documentation

Documentation for this image is stored in the [`snmptraps/` directory](https://github.com/zabbix/zabbix-docker/tree/6.0/Dockerfiles/snmptraps) of the [`zabbix/zabbix-docker` GitHub repo](https://github.com/zabbix/zabbix-docker/). Be sure to familiarize yourself with the [repository's `README.md` file](https://github.com/zabbix/zabbix-docker/blob/6.0/README.md) before attempting a pull request.

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
