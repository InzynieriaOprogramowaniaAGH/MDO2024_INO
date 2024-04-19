ARG IMAGE_TAG
ARG VERSION
ARG RELEASE

FROM irssi-build:$IMAGE_TAG

RUN --mount=type=cache,target=/var/cache/yum \
    dnf -y install \
    cmake \
    openssl-devel && \
    dnf clean all

ENV VERSION=$VERSION \
    RELEASE=$RELEASE

COPY ./irssi-$VERSION-$RELEASE.fc39.src.rpm /

RUN rpmbuild --rebuild irssi-$VERSION-$RELEASE.fc39.src.rpm && dnf -y install /root/rpmbuild/RPMS/irssi-$VERSION-$RELEASE.fc39.rpm

ENTRYPOINT irssi 

CMD ["--version"]



