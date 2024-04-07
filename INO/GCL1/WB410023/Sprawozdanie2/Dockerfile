FROM ubuntu:latest

RUN apt-get update && apt-get install -y git

ARG TOKEN
ENV GITHUB_TOKEN=${TOKEN}

RUN git clone https://$GITHUB_TOKEN@github.com/fairoos-nm/Game-of-Life.git

WORKDIR /Game-of-Life

RUN apt-get update && apt-get install -y python3 python3-pip

RUN python3 -m pip install pytest
