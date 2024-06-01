FROM fedora:39

WORKDIR /root

RUN dnf update -y && dnf install -y 

CMD