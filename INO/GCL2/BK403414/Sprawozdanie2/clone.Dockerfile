FROM ubuntu:latest

RUN apt-get update

RUN mkdir input
RUN --mount=type=bind,source=wyjsciowy,target=/input

WORKDIR /input

RUN git clone https://github.com/alt-romes/programmer-calculator.git