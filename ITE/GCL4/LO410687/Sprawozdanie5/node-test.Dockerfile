FROM node-build
WORKDIR /notes-app-cicd
RUN npm test
