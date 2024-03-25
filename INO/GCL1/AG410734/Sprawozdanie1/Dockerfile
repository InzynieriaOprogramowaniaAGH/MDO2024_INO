FROM fedora:latest

RUN dnf -y update
RUN dnf -y install git

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git

WORKDIR /app

CMD ["bash"]