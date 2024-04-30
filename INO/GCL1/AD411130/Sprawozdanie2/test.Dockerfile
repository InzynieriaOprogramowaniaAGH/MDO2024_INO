FROM build:tag
WORKDIR /eventsourcemock
RUN npm install -g jest
RUN npm run test