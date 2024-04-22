FROM fedora:latest

VOLUME /tmp

RUN dnf -y update && dnf -y install git
RUN git clone https://github.com/taniarascia/takenote.git /tmp/takenote
