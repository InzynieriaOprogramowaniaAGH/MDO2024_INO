FROM node:latest

# Clone this project
RUN git clone https://github.com/devenes/node-js-dummy-test

# Access
WORKDIR cd node-js-dummy-test

# install all needed dependencies
RUN npm install
