FROM irssi-builder
WORKDIR /irssi
RUN ninja -C Build install
ENTRYPOINT [ "irssi" ]