FROM node:12

RUN dnf -y update && dnf -y install git
RUN git clone https://github.com/taniarascia/takenote.git 
WORKDIR /takenote
RUN npm install