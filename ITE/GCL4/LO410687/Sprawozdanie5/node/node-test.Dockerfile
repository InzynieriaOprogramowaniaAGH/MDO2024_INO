FROM web-app
WORKDIR /fullstack-nextjs-app-template
COPY . . 
RUN npm install

RUN npm test
