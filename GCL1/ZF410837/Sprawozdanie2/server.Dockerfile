FROM fedora:latest

#instalacja iperf3
RUN dnf install -y iperf3 && dnf clean all

# uruchamianie serwera
CMD ["iperf3", "-s"]