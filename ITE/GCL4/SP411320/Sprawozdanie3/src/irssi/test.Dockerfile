FROM irssi-build
WORKDIR /root/irssi/Build
RUN ninja test
