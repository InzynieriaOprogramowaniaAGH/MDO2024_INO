ARG IMAGE_TAG

FROM irssi-build:$IMAGE_TAG

RUN --mount=type=cache,target=/var/cache/yum \
    dnf -y install \
    rpm-build \
    rpm-devel \
    rpmlint \
    make \
    python \
    bash \
    coreutils \
    diffutils \
    patch \
    rpmdevtools

WORKDIR /

ARG VERSION
ARG RELEASE

RUN mv irssi irssi-$VERSION && \
    tar -cvzf irssi-$VERSION.tar.gz irssi-$VERSION && \
    rpmdev-setuptree && \
    cp irssi-$VERSION.tar.gz /root/rpmbuild/SOURCES/

WORKDIR /root/rpmbuild/SPECS

COPY ./irssi.spec .

RUN rpmbuild -bs irssi.spec && \
    rpmlint irssi.spec && \
    rpmlint ../SRPMS/irssi-$VERSION-$RELEASE.fc39.src.rpm && \
    mkdir -p /releases/source_rpm/ && \
    mv /root/rpmbuild/SRPMS/irssi-$VERSION-$RELEASE.fc39.src.rpm /releases/source_rpm/
