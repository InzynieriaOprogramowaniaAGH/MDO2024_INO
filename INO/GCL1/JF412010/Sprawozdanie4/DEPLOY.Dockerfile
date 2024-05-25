# syntax=docker/dockerfile:1

FROM node:20

WORKDIR /node_app

RUN git clone https://github.com/JakubFicek/node-js-tests-sample.git
WORKDIR /node-js-tests-sample

# FROM NPM REPOSITORY
RUN npm install node-game-unit-tests

# URUCHOMIENIE APLIKACJI
CMD ["npm", "test"]