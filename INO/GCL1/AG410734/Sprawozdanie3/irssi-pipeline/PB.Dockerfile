FROM bldr

ARG VERSION
ARG RELEASE

RUN mkdir -p /artifacts-${VERSION}-${RELEASE}
RUN chmod 777 /Build/src/fe-text/irssi
COPY /Build/src/fe-text/irssi /artifacts-${VERSION}-${RELEASE}/irssi

