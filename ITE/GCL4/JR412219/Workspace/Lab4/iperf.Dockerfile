FROM fedora:39

RUN dnf update -y && dnf install -y iperf3 ncurses hostname tldr