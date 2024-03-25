FROM irssi-builder

RUN ninja -C /irssi/Build
RUN ninja test
