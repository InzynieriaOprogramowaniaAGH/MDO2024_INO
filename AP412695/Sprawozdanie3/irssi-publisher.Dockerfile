FROM irssi-deploy AS deploy
FROM fedora:40

RUN mkdir -p /rpm && mkdir -p /src

COPY --from=deploy /src /src
COPY --from=deploy /rpm /rpm

RUN dnf install -y \
    perl \
    glib2 \
    ncurses-libs \
    utf8proc \
    openssl

RUN dnf install -y /rpm/irssi-Test-1.fc40.x86_64.rpm

ENTRYPOINT irssi

CMD ['--version']
