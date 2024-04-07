FROM node:latest

RUN mkdir wejscie
RUN mkdir wyjscie

RUN --mount=type=bind,source=wejsciowy,target=/wejscie,rw
RUN --mount=type=bind,source=wyjsciowy,target=/wyjscie,rw
WORKDIR /wejscie
RUN git clone https://github.com/dmaciej409926/simple-nodejs.git
WORKDIR /wejscie/simple-nodejs
RUN npm install
RUN cp -r node_modules ../../wyjscie/Dockerfile_node_modules
