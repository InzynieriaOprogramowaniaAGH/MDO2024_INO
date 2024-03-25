FROM node:latest

RUN git clone https://github.com/dmaciej409926/simple-nodejs.git
WORKDIR /simple-nodejs
RUN npm install
