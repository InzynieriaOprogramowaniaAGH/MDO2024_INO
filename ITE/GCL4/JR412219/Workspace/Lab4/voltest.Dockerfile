FROM fedora
VOLUME /root/vol
WORKDIR /root/vol
RUN dnf -y install git
RUN git clone https://github.com/irssi/irssi.git