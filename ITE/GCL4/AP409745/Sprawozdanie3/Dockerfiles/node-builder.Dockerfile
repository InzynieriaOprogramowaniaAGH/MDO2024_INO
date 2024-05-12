FROM node

RUN apt-get update -y
RUN apt-get install git -y
RUN git clone https://github.com/devenes/node-js-dummy-test.git
WORKDIR /node-js-dummy-test

RUN npm install

CMD ["npm", "start"]