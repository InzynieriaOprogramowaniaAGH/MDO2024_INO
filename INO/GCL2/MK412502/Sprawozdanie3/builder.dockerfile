FROM node:latest

#Cloning
RUN git clone https://github.com/expressjs/express.git

WORKDIR express

# RUN npm install express

RUN npm install -g express-generator@4

RUN express ./tmp/foo

WORKDIR tmp/foo

RUN npm install