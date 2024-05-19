FROM notes-app
WORKDIR /notes-app-cicd
COPY . . 
RUN npm install

RUN npm test
