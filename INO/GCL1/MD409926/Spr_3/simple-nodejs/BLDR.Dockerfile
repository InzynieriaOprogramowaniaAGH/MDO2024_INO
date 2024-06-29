FROM node:18
RUN apt-get update -y
RUN apt-get install git -y
RUN git clone https://github.com/dmaciej409926/simple-nodejs.git
WORKDIR /simple-nodejs
RUN npm install

CMD ["npm", "start"]