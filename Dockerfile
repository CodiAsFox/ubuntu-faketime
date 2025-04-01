# ----------------------------------------
# Builder Stage - build libfaketime
# ----------------------------------------
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install -y --no-install-recommends build-essential git ca-certificates && \
  git clone https://github.com/wolfcw/libfaketime /libfaketime

WORKDIR /libfaketime

RUN make && make install

# ----------------------------------------
# Verify libfaketime in Ubuntu
# ----------------------------------------
FROM ubuntu:22.04 AS verify-date

COPY --from=builder /usr/local/lib/faketime/libfaketimeMT.so.1 /lib/faketime.so

ENV LD_PRELOAD=/lib/faketime.so \
  FAKETIME="-15d" \
  DONT_FAKE_MONOTONIC=1

# This should show a date ~15 days in the past
RUN date

# ----------------------------------------
# Verify with Java/Groovy
# ----------------------------------------
FROM groovy:jre AS verify-java

COPY --from=builder /usr/local/lib/faketime/libfaketimeMT.so.1 /lib/faketime.so

ENV LD_PRELOAD=/lib/faketime.so \
  FAKETIME="-15d" \
  DONT_FAKE_MONOTONIC=1

RUN groovy -e "println new Date()"

# ----------------------------------------
# Final Minimal Image
# ----------------------------------------
FROM scratch AS faketime-runtime

COPY --from=builder /usr/local/lib/faketime/libfaketimeMT.so.1 /faketime.so
