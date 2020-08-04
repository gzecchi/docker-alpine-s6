# Docker Image: alpine-s6

[![Build Status](https://travis-ci.com/gzecchi/docker-alpine-s6.svg?branch=master)](https://hub.docker.com/r/gzecchi/alpine-s6)
[![Docker Pulls](https://img.shields.io/docker/pulls/gzecchi/alpine-s6.svg)](https://hub.docker.com/r/gzecchi/alpine-s6)
[![Docker Stars](https://img.shields.io/docker/stars/gzecchi/alpine-s6.svg)](https://hub.docker.com/r/gzecchi/alpine-s6)
[![Docker Layers](https://images.microbadger.com/badges/image/gzecchi/alpine-s6.svg)](https://microbadger.com/images/gzecchi/alpine-s6)

## Introduction

This is a multi architecture Base Alpine Image with the S6 Overlay

[Alpine Linux](https://alpinelinux.org/) + [S6 Overlay](https://github.com/just-containers/s6-overlay)

## Table of Contents

- [Authors](#authors)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Quick Start](#quick-start)
- [Configuration](#configuration)
  - [Data-Volumes](#data-volumes)
  - [Environment Variables](#environment-variables)
    - [Container Options](#container-options)
    - [SMTP Options](#smtp-options)
    - [Permissions](#permissions)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Usage](#usage)
  - [Shell Access](#shell-access)
- [References](#references)

## Authors

- [Gianluca Zecchi](https://www.gianlucazecchi.com)

## Prerequisites

No prerequisites required

## Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/r/gzecchi/alpine-s6) and
is the recommended method of installation.

``bash
docker pull gzecchi/alpine-s6:(imagetag)
``

The following image tags are available:
* `3.12` - Alpine 3.12
* `edge` - Alpine edge
* `latest` - Alpine 3.12

### Quick Start

Utilize this image as a base for further builds. By default, it does not start the S6 Overlay system, but
Bash. Please visit the [s6 overlay repository](https://github.com/just-containers/s6-overlay) for
instructions on how to enable the S6 init system when using this base or look at some of my other images
which use this as a base.

## Configuration

### Data-Volumes

The following directories are used for configuration and can be mapped for persistent storage.

| Directory                           | Description                          |
| ----------------------------------- | ------------------------------------ |
| `/assets/cron-custom`               | Drop custom CronTabs here            |

### Environment Variables

Below is the complete list of available options that can be used to customize your installation.

#### Container Options
| Parameter             | Description                                                            | Default          |
| --------------------- | ---------------------------------------------------------------------- | ---------------- |
| `COLORIZE_OUTPUT`     | Enable/Disable colorized console output                                | `TRUE`           |
| `CONTAINER_LOG_LEVEL` | Control level of output of container `INFO`, `WARN`, `NOTICE`, `DEBUG` | Default `NOTICE` |
| `DEBUG_MODE`          | Enable debug mode                                                      | `FALSE`          |
| `DEBUG_SMTP`          | Setup mail catch all on port 1025 (SMTP) and 8025 (HTTP)               | `FALSE`          |
| `ENABLE_CRON`         | Enable Cron                                                            | `TRUE`           |
| `ENABLE_LOGROTATE`    | Enable Logrotate (if Cron enabled)                                     | `TRUE`           |
| `ENABLE_SMTP`         | Enable SMTP services                                                   | `TRUE`           |
| `SKIP_SANITY_CHECK`   | Disable container startup routine check                                | `FALSE`          |
| `TZ`                  | Set Timezone                                                           | `Etc/GMT`        |

If you wish to have this sends mail, set `ENABLE_SMTP=TRUE` and configure the following environment variables.
See the [MSMTP Configuration Options](http://msmtp.sourceforge.net/doc/msmtp.html) for further information on options to configure MSMTP.

#### SMTP Options
| Parameter             | Description                                       | Default         |
| --------------------- | ------------------------------------------------- | --------------- |
| `ENABLE_SMTP_GMAIL`   | Add setting to support sending through Gmail SMTP | `FALSE`         |
| `SMTP_HOST`           | Hostname of SMTP Server                           | `postfix-relay` |
| `SMTP_PORT`           | Port of SMTP Server                               | `25`            |
| `SMTP_DOMAIN`         | HELO Domain                                       | `docker`        |
| `SMTP_MAILDOMAIN`     | Mail Domain From                                  | `local`         |
| `SMTP_AUTHENTICATION` | SMTP Authentication                               | `none`          |
| `SMTP_USER`           | Enable SMTP services                              | `user`          |
| `SMTP_PASS`           | Enable Zabbix Agent                               | `password`      |
| `SMTP_TLS`            | Use TLS                                           | `off`           |
| `SMTP_STARTTLS`       | Start TLS from within session                     | `off`           |
| `SMTP_TLSCERTCHECK`   | Check remote certificate                          | `off`           |

If you enable `DEBUG_PERMISSIONS=TRUE` all the users and groups have been modified in accordance with
environment variables will be displayed in output.
e.g. If you add `USER_NGINX=1000` it will reset the containers `nginx` user id from `82` to `1000` -
Hint, also change the Group ID to your local development users UID & GID and avoid Docker permission issues when developing.

#### Permissions
| Parameter              | Description                                                                 |
| ---------------------- | --------------------------------------------------------------------------- |
| `USER_<USERNAME>`      | The user's UID in /etc/passwd will be modified with new UID                 |
| `GROUP_<GROUPNAME>`    | The group's GID in /etc/group and /etc/passwd will be modified with new GID |
| `GROUP_ADD_<USERNAME>` | The username will be added in /etc/group after the group name defined       |

### Networking

The following ports are exposed.

| Port    | Description                                  |
| ------- | -------------------------------------------- |
| `1025`  | `DEBUG_MODE` & `DEBUG_SMTP` SMTP Catcher     |
| `8025`  | `DEBUG_MODE` & `DEBUG_SMTP` SMTP HTTP Viewer |

# Debug Mode

When using this as a base image, create statements in your startup scripts to check for existence of `DEBUG_MODE=TRUE`
and set various parameters in your applications to output more detail, enable debugging modes, and so on.
In this base image it does the following:

* Enables MailHog mailcatcher, which replaces `/usr/sbin/sendmail` with it's own catchall executable. It also opens
port `1025` for SMTP trapping, and you can view the messages it's trapped at port `8025`

## Maintenance

See the [S6 Overlay Documentation](https://github.com/just-containers/s6-overlay) for details on how to manage services.

## Usage

x86_64:

```shell
docker run gzecchi/alpine-s6
```

ARM:

```shell
docker run gzecchi/alpine-s6:armfh
```

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

``bash
docker exec -it gzecchi/alpine-s6 bash
``

## References

* <https://www.alpinelinux.org>
* <https://github.com/just-containers/s6-overlay>