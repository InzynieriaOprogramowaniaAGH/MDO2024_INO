FROM node
WORKDIR /root/dummy
RUN git clone https://github.com/devenes/node-js-dummy-test .
RUN npm i
