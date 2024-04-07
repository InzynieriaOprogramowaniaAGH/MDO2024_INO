# syntax=docker/dockerfile:1

FROM node:latest

RUN git clone https://github.com/aws-samples/node-js-tests-sample.git
WORKDIR /node-js-tests-sample
RUN npm install