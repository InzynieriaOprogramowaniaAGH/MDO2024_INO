FROM node-build
WORKDIR /node-js-tests-sample
RUN npm test
CMD ["npm", "start"]