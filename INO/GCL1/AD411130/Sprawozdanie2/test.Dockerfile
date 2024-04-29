FROM build:tag1
WORKDIR /eventsourcemock
RUN npm install -g jest
RUN npm run test