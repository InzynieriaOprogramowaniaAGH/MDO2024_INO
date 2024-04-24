ARG IMAGE_TAG

FROM irssi-publish-rpm:$IMAGE_TAG AS build-on-deploy

RUN --mount=type=cache,target=/var/cache/yum \
    dnf -y install \
    cmake \
    openssl-devel

ARG VERSION
ARG RELEASE

WORKDIR /source_rpm

RUN rpmbuild --rebuild --nodebuginfo irssi-$VERSION-$RELEASE.fc39.src.rpm && \
    dnf -y install /root/rpmbuild/RPMS/x86_64/irssi-$VERSION-$RELEASE.fc39.x86_64.rpm

FROM fedora:39 AS deploy 

ARG VERSION
ARG RELEASE

RUN mkdir -p /rpm && mkdir -p /source_rpm

COPY --from=build-on-deploy /source_rpm /source_rpm
COPY --from=build-on-deploy /root/rpmbuild/RPMS/x86_64/irssi-$VERSION-$RELEASE.fc39.x86_64.rpm /rpm/

RUN dnf -y install \
    glib2 \
    perl \
    ncurses-libs \
    utf8proc \
    openssl && \
    dnf clean all && \
    dnf -y install /rpm/irssi-$VERSION-$RELEASE.fc39.x86_64.rpm

ENTRYPOINT ["irssi"]

CMD ["--version"]
