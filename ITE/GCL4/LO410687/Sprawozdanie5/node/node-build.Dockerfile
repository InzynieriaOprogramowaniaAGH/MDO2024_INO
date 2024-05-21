FROM node:20
RUN apt-get update -y
RUN apt-get install git -y
RUN git clone https://github.com/xizon/fullstack-nextjs-app-template
RUN npm i next@latest react@latest react-dom@latest eslint-config-next@latest
WORKDIR /fullstack-nextjs-app-template
RUN npm install
 
CMD ["npm", "start"]