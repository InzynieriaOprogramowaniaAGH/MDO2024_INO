ARG IMAGE_TAG

FROM irssi-publish-rpm:$IMAGE_TAG

RUN --mount=type=cache,target=/var/cache/yum \
    dnf -y install \
    cmake \
    openssl-devel && \
    dnf clean all

ARG VERSION
ARG RELEASE

WORKDIR /source_rpm

RUN rpmbuild --rebuild --nodebuginfo irssi-$VERSION-$RELEASE.fc39.src.rpm && dnf -y install /root/rpmbuild/RPMS/irssi-$VERSION-$RELEASE.fc39.rpm

ENTRYPOINT irssi 

CMD ["--version"]



