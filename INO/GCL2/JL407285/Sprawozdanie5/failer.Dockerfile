FROM node:latest
RUN git clone https://github.com/devenes/node-js-dummy-test
WORKDIR /node-js-dummy-test
RUN npm install

CMD ["sh", "-c", "exit 1"]