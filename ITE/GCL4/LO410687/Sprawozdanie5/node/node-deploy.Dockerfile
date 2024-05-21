FROM web-app

WORKDIR /fullstack-nextjs-app-template

COPY . .

RUN npm install

RUN npm run build

EXPOSE 3000

ENTRYPOINT npm run deploy:prod 
