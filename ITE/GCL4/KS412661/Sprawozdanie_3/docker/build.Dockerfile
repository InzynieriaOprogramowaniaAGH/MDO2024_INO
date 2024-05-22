FROM node:16-alpine

RUN apt-get update -y
RUN apt-get install git -y

RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR /node-js-dummy-test

RUN npm install