FROM fedora:latest
RUN dnf -y update && dnf -y install glib2 utf8proc-devel libxcrypt
