FROM bldr

ARG VERSION
ARG RELEASE

RUN mkdir -p /artifacts-${VERSION}-${RELEASE}
COPY /irssi/Build/src/fe-text/irssi /artifacts-${VERSION}-${RELEASE}/irssi

