FROM node-build

WORKDIR /node-red
RUN npm run build

EXPOSE 5000

ENTRYPOINT npm run prod