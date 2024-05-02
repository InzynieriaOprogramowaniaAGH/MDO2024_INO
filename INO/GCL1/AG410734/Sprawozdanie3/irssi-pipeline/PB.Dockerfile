FROM bldr

ARG VERSION
ARG RELEASE

RUN mkdir -p /artifacts-${VERSION}-${RELEASE}
RUN ls
RUN chmod 777 irssi/Build/src/fe-text/irssi
RUN cp irssi/Build/src/fe-text/irssi /artifacts-${VERSION}-${RELEASE}

