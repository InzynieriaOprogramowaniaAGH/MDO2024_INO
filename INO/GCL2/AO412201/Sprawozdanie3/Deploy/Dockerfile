FROM node:latest
WORKDIR /app
COPY ./build_artifacts .
RUN npm install -g serve
CMD serve -s build
