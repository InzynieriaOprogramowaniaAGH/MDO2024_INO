FROM ubuntu

ARG VERSION
ARG RELEASE

RUN apt-get update \
    && apt-get install -y libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY artifacts-${VERSION}-${RELEASE}/irssi /usr/local/bin/