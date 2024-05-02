FROM bldr AS builder

ARG VERSION
ARG RELEASE

RUN mkdir -p /artifacts-${VERSION}-${RELEASE}
RUN pwd
COPY irssi/Build/src/fe-text/irssi /artifacts-${VERSION}-${RELEASE}/irssi

