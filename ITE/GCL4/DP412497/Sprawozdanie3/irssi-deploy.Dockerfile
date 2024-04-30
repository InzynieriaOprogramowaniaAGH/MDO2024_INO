FROM irssi-publish-rpm AS build-on-deploy

RUN dnf -y install cmake openssl-devel

WORKDIR /source_rpm

RUN rpmbuild --rebuild --nodebuginfo irssi-fc39.src.rpm
    
RUN dnf -y install /root/rpmbuild/RPMS/x86_64/irssi-fc39.x86_64.rpm






FROM fedora:39 AS deploy 

RUN mkdir -p /rpm && mkdir -p /source_rpm

COPY --from=build-on-deploy /source_rpm /source_rpm
COPY --from=build-on-deploy /root/rpmbuild/RPMS/x86_64/irssifc39.x86_64.rpm /rpm/

RUN dnf -y install lib2 perl ncurses-libs utf8proc openssl-devel
RUN dnf clean all
RUN dnf -y install /rpm/irssi-fc39.x86_64.rpm

ENTRYPOINT irssi

CMD ["--version"]