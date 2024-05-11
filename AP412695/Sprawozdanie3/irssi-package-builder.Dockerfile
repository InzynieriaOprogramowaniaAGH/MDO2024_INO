FROM irssi-build

RUN dnf -y install \
    rpm-build \
    rpm-devel \
    rpmlint \
    make \
    coreutils \
    patch \
    rpmdevtools \
    git \
    python \
    bash \
    gdb \
    cmake

WORKDIR /

RUN tar -czvf irssi.tar.gz irssi
RUN rpmdev-setuptree
RUN cp irssi.tar.gz /root/rpmbuild/SOURCES/

WORKDIR /root/rpmbuild/SPECS

COPY ./irssi.spec .

RUN rpmbuild -bs irssi.spec
RUN rpmlint ../SRPMS/irssi-Test-1.fc40.src.rpm
RUN mkdir -p /src
RUN mv /root/rpmbuild/SRPMS/irssi-Test-1.fc40.src.rpm /src