FROM irssi-publisher AS build-on-deploy

RUN dnf -y install cmake openssl-devel

WORKDIR /source_rpm

RUN rpmbuild --rebuild --nodebuginfo irssi-1-1.src.rpm
    
RUN dnf -y install /root/rpmbuild/RPMS/x86_64/irssi-1-1.x86_64.rpm






FROM fedora:39 AS deploy 

RUN mkdir -p /rpm
RUN mkdir -p /source_rpm

COPY --from=build-on-deploy /source_rpm /source_rpm
COPY --from=build-on-deploy /root/rpmbuild/RPMS/x86_64/irssi-1-1.x86_64.rpm /rpm/

RUN dnf -y install glib2-devel perl ncurses-libs utf8proc openssl-devel
RUN dnf clean all
RUN dnf -y install /rpm/irssi-1-1.x86_64.rpm

ENTRYPOINT irssi

CMD ["--version"]