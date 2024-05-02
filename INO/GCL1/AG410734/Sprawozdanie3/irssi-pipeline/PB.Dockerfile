FROM bldr

ARG VERSION
ARG RELEASE

RUN mkdir -p /artifacts-${VERSION}-${RELEASE}
RUN find . -type f -executable -name 'irssi'

