FROM node:18

RUN git clone https://github.com/dmaciej409926/simple-nodejs.git
WORKDIR /simple-nodejs

# FROM NPM REPOSITORY
RUN npm install

# URUCHOMIENIE APLIKACJI
RUN npm test