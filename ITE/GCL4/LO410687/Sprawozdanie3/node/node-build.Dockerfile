FROM node
RUN apt-get update -y
RUN apt-get install git -y
RUN git clone https://github.com/node-red/node-red.git
WORKDIR /node-red
RUN npm install

 
CMD ["npm", "start"]