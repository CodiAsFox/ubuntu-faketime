FROM groovy:alpine
COPY --from=ghcr.io/codiasfox/ubuntu-faketime  /faketime.so /lib/faketime.so
ENV LD_PRELOAD=/lib/faketime.so \
  DONT_FAKE_MONOTONIC=1
