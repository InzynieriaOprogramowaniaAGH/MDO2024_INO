FROM node:latest

RUN git clone https://github.com/devenes/node-js-dummy-test.git
WORKDIR node-js-dummy-test
RUN npm install

CMD ["sh", "-c", "exit 1"] 

