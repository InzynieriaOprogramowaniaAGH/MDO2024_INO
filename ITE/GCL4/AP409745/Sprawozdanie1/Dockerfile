# syntax=docker/dockerfile:1
FROM ubuntu

RUN apt update && apt install -y git ssh

WORKDIR /github

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO.git