FROM fedora:latest

RUN dnf update -y && dnf install -y git

ARG TOKEN
ENV GITHUB_TOKEN=${TOKEN}

RUN git clone https://$GITHUB_TOKEN@github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git
