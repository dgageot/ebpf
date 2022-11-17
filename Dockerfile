# syntax=docker/dockerfile:1@sha256:9ba7531bd80fb0a858632727cf7a112fbfd19b17e94c4e84ced81e24ef1a0dbc

# docker run -it --rm --pid=host --privileged=true -v /lib/modules:/lib/modules dgageot/ebpf
# profile -adf -p $(pgrep fibo) 15 > profile
# /flame/FlameGraph/flamegraph.pl < profile --colors java --hash > flame.svg

FROM docker/for-desktop-kernel:5.15.49-13422a825f833d125942948cf8a8688cef721ead as kernel

FROM busybox as linux
COPY --link --from=kernel /kernel-dev.tar .
RUN tar xf kernel-dev.tar

FROM alpine as flamegraphs
RUN apk add --no-cache git
WORKDIR /flame
RUN git clone --depth=1 https://github.com/brendangregg/FlameGraph

FROM alpine:3.16
RUN apk add --no-cache bcc-tools bcc-doc perl
ENV PATH=/usr/share/bcc/tools/:$PATH
VOLUME /lib/modules
COPY --link --from=flamegraphs /flame flame
COPY --link --from=linux /usr/src/linux-headers-5.15.49-linuxkit /usr/src/linux-headers-5.15.49-linuxkit
COPY entrypoint.sh /
