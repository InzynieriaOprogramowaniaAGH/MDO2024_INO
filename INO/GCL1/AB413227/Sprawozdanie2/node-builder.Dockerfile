FROM node:latest

RUN git clone https://github.com/devenes/node-js-dummy-test.git

WORKDIR /node-js-dummy-test

RUN npm install -g npm@10.5.1
RUN npm install --save-dev babel-cli
RUN npm run build
