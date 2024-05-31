FROM alpine:latest

LABEL latest

RUN <<EOF
    set -xe
    apk upgrade --update --no-cache

    apk add --no-cache -U   \
        ca-certificates     \
        curl                \
        findmnt             \
        fuse                \
        libacl              \
        sshfs               \
        tzdata              \
        docker              \
        btrfs-tools         \
        supercronic
    apk upgrade --no-cache
EOF

ENV LANG='en_US.UTF-8'                   \
    LANGUAGE='en_US.UTF-8'               \
    TERM='xterm'                         \
    TZ="Europe/London"

COPY --chmod 744 btrfs-snaptree /

VOLUME /root/.borgmatic
VOLUME /root/.config/borg
VOLUME /root/.cache/borg

ENTRYPOINT [ "/init.sh" ]
