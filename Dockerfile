ARG ALPINE_VERSION
FROM --platform=$BUILDPLATFORM alpine:${ALPINE_VERSION:-3.12}
LABEL maintainer="Gianluca Zecchi (gian.zecchi@gmail.com)"

### Set Defaults
ENV S6_OVERLAY_VERSION=v2.0.0.1 \
    DEBUG_MODE=FALSE \
    TIMEZONE=Etc/GMT \
    ENABLE_CRON=TRUE \
    ENABLE_SMTP=TRUE

RUN set -x && apk update && \
    apk upgrade && \
### Install MailHog
    apk add --no-cache -t .mailhog-build-deps \
            go \
            git \
            musl-dev \
            && \
    mkdir -p /usr/src/gocode && \
    cd /usr/src && \
    export GOPATH=/usr/src/gocode && \
    go get github.com/mailhog/MailHog && \
    go get github.com/mailhog/mhsendmail && \
    mv /usr/src/gocode/bin/MailHog /usr/local/bin && \
    mv /usr/src/gocode/bin/mhsendmail /usr/local/bin && \
    rm -rf /usr/src/gocode && \
    apk del --purge \
            .mailhog-build-deps && \
    \
    adduser -D -u 1025 mailhog && \
    \
### Add core utils
    apk add -t .base-rundeps \
            bash \
            busybox-extras \
            curl \
            grep \
            less \
            logrotate \
            msmtp \
            nano \
            sudo \
            tzdata \
            vim \
            && \
    rm -rf /var/cache/apk/* && \
    rm -rf /etc/logrotate.d/acpid && \
    rm -rf /root/.cache /root/.subversion && \
    cp -R /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    \
    ## Quiet down sudo
    echo "Set disable_coredump false" > /etc/sudo.conf && \
    \
### S6 Installation
    case "${QEMU_ARCH}" in \
        "linux/amd64") S6_ARCH='amd64';; \
        "linux/386") S6_ARCH='x86';; \
        "linux/arm64") S6_ARCH='aarch64';; \
        "linux/arm/v7") S6_ARCH='armhf';; \
        "linux/arm/v6") S6_ARCH='armhf';; \
        *) echo "Unsupported Architecture"; exit 1 ;; \
    esac && \
    curl -SL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.gz | tar xvzf - -C / && \
    mkdir -p /assets/cron && \
### Clean Up
    apk del --purge \
    rm -rf /tmp/* \
    rm -rf /usr/src/*

### Networking Configuration
EXPOSE 1025 8025

### Add Folders
ADD /install /

### Entrypoint Configuration
ENTRYPOINT ["/init"]