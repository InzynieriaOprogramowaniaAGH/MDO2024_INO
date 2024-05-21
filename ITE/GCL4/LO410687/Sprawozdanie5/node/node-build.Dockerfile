FROM node:20
RUN apt-get update -y
RUN apt-get install git -y
RUN git clone https://github.com/xizon/fullstack-nextjs-app-template
WORKDIR /fullstack-nextjs-app-template
RUN npm install
 
CMD ["npm", "start"]