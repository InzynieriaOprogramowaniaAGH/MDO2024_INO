FROM irssi-package

WORKDIR /src

RUN rpmbuild --rebuild --nodebuginfo irssi-Test-1.fc40.src.rpm
RUN mkdir /rpm
RUN mv /root/rpmbuild/RPMS/x86_64/irssi-Test-1.fc40.x86_64.rpm /rpm

