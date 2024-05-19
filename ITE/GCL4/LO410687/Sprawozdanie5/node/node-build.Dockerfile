FROM node:20
RUN apt-get update -y
RUN apt-get install git -y
RUN git clone https://github.com/pavanbelagatti/notes-app-cicd.git 
WORKDIR /notes-app-cicd
RUN npm install
 
CMD ["npm", "start"]