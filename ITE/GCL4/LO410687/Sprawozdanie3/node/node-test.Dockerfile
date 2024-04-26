FROM node-build
WORKDIR /node-red
RUN npm test
CMD ["npm", "start"]