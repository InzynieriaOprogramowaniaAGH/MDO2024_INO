FROM fedora
WORKDIR /vol
RUN dnf -y update && dnf install -y git
RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git /vol/repository
VOLUME /app/repository

