FROM notes-app

WORKDIR /notes-app-cicd

COPY . .

RUN npm install

CMD ["npm", "start"]

EXPOSE 3000