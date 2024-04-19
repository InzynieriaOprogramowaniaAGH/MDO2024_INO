ARG IMAGE_TAG
ARG VERSION
ARG RELEASE

FROM fedora:39

RUN --mount=type=cache,target=/var/cache/yum \
    dnf -y update && \
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
    rpmdevtools \
    gcc \
    git && \
    dnf clean all

WORKDIR /

RUN mv irssi irssi-$VERSION && \
    tar -cvzf irssi-$VERSION.tar.gz irssi-$VERSION && \
    rpmdev-setuptree && \
    cp irssi-$VERSION.tar.gz /root/rpmbuild/SOURCES/

WORKDIR /root/rpmbuild/SPECS

COPY ./irssi.spec .

RUN rpmbuild -bs irssi.spec && \
    rpmlint irssi.spec && \
    rpmlint ../SRPMS/irssi-$VERSION-$RELEASE.fc39.src.rpm

COPY /root/rpmbuild/SRPMS/irssi-$VERSION-$RELEASE.fc39.src.rpm .