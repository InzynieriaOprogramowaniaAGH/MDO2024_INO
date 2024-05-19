FROM node
RUN git clone https://github.com/gcedo/eventsourcemock.git
WORKDIR /eventsourcemock
RUN npm install -g npm@10.5.1
RUN npm install --save-dev babel-cli
RUN npm run build