FROM node-build

WORKDIR /notes-app-cicd
RUN npm run build

EXPOSE 3000

ENTRYPOINT node app.js