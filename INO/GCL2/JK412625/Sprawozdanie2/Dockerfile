FROM node:18-bullseye as stage1

RUN apt update && apt upgrade -y
WORKDIR /app
RUN git clone https://github.com/pencilblue/pencilblue.git
RUN cd pencilblue && npm install

FROM stage1 as stage2

WORKDIR /app/pencilblue

CMD ["npm", "test"]