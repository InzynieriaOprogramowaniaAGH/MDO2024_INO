FROM ubuntu

ARG VERSION
ARG RELEASE

COPY artifacts-${VERSION}-${RELEASE}/irssi /usr/local/bin/