FROM fedora:latest

WORKDIR /app

RUN dnf -y update && dnf -y install git && dnf clean all

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git

CMD ["bash"]
