# syntax=docker/dockerfile:1

FROM node:19

RUN git clone https://github.com/JakubFicek/node-js-tests-sample.git
WORKDIR /node-js-tests-sample

COPY .npmrc /node-js-tests-sample/.npmrc

RUN npm install node-game-unit-tests

RUN npm test