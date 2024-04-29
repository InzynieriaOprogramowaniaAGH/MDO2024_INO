FROM node:18
RUN apt-get update -y
RUN apt-get install git -y
RUN git clone https://github.com/loprych/node-js-tests-sample
WORKDIR /node-js-tests-sample
RUN npm install

 
CMD ["npm", "start"]