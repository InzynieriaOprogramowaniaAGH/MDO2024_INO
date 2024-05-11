FROM bldr

ARG VERSION
ARG RELEASE

RUN mkdir -p /artifacts-${VERSION}-${RELEASE}
RUN cp Build/src/fe-text/irssi /artifacts-${VERSION}-${RELEASE}

