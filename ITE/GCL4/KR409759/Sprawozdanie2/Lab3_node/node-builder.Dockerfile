FROM node

RUN git clone https://github.com/devenes/node-js-dummy-test ./node

WORKDIR /node

RUN npm install


