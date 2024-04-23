FROM node-build

WORKDIR /quick-example-of-testing-in-nodejs
RUN npm run build

EXPOSE 5000

ENTRYPOINT npm run prod