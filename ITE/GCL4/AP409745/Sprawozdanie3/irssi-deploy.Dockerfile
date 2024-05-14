FROM irssi-publish
#Instalujemy zaleznosci
RUN dnf -y install cmake openssl-devel

WORKDIR /source_rpm
#Przebudowujemy pakiet i instalujemy go
RUN rpmbuild --rebuild --nodebuginfo irssi-1-1.src.rpm 
RUN dnf -y install /root/rpmbuild/RPMS/x86_64/irssi-1-1.x86_64.rpm

FROM fedora:39 AS deploy 

#Kopiujemy zpakowane Irssi z obrazu publishowego, do aktualnego
RUN mkdir -p /rpm
RUN mkdir -p /source_rpm
COPY --from=irssi-publish /source_rpm /source_rpm
COPY --from=irssi-publish /root/rpmbuild/RPMS/x86_64/irssi-1-1.x86_64.rpm /rpm/

#Instalujemy zależności, czyścimy cache i instalujemy nasze RPMowe Irssi
RUN dnf -y install glib2-devel perl ncurses-libs utf8proc openssl-devel
RUN dnf clean all
RUN dnf -y install /rpm/irssi-1-1.x86_64.rpm

#Ustawiamy Entrypoint kontenera i wysyłamy komendę sprawdzenia wersji
ENTRYPOINT irssi
CMD ["--version"]