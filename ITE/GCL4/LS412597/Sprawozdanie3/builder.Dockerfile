FROM node:12-alpine

RUN apk update && \
    apk add --no-cache git && \
    git clone https://github.com/devenes/node-js-dummy-test.git  && \
    apk del git
WORKDIR /takenote
RUN npm install