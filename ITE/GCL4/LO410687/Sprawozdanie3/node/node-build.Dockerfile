FROM node:latest

RUN apt-get update -y
RUN apt-get install git -y
RUN git clone https://github.com/Lissy93/quick-example-of-testing-in-nodejs.git
WORKDIR quick-example-of-testing-in-nodejs
RUN npm install

 
CMD ["npm", "start"]