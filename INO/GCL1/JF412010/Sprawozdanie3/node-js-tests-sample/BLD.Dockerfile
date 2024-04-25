# syntax=docker/dockerfile:1

FROM node:20

RUN git clone https://github.com/JakubFicek/node-js-tests-sample.git
WORKDIR /node-js-tests-sample
RUN npm install