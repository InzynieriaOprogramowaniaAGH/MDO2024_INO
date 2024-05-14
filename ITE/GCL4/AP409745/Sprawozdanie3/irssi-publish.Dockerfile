#Bazujemy na builderze
FROM irssi-builder
#instalujemy depenencies RPMu
RUN  dnf install -y gcc rpm-build rpm-devel rpmlint make python bash coreutils diffutils patch rpmdevtools

#Pakujemy nasz build do archiwum .tar
WORKDIR /
RUN rpmdev-setuptree
RUN tar -cvzf irssi.tar.gz irssi
RUN cp irssi.tar.gz /root/rpmbuild/SOURCES/

WORKDIR /root/rpmbuild/SPECS

#Kopiujemy plik specyfikacji i w oparciu o niego budujemy paczkę RPM
COPY ./irssi.spec .
RUN rpmbuild -bs irssi.spec
RUN rpmlint irssi.spec
RUN rpmlint ../SRPMS/irssi-fc39.src.rpm
RUN mkdir -p /source_rpm
RUN mv /root/rpmbuild/SRPMS/irssi-fc39.src.rpm /source_rpm