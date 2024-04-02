FROM node:18-bullseye

RUN apt update && apt upgrade -y
WORKDIR /app
RUN git clone https://github.com/pencilblue/pencilblue.git
RUN cd pencilblue && npm install