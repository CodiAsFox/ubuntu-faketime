FROM ubuntu:22.04
COPY --from=ghcr.io/codiasfox/ubuntu-faketime  /faketime.so /lib/faketime.so
ENV LD_PRELOAD=/lib/faketime.so
