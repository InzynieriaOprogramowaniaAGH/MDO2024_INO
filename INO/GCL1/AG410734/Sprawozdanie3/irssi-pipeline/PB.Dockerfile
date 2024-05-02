FROM bldr AS builder

ARG VERSION
ARG RELEASE

RUN mkdir -p /artifacts-${VERSION}-${RELEASE}
COPY ./Build/src/fe-text/irssi /artifacts-${VERSION}-${RELEASE}/irssi

