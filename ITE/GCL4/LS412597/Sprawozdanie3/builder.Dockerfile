FROM node:12

RUN git clone https://github.com/taniarascia/takenote.git 
WORKDIR /takenote
RUN npm install