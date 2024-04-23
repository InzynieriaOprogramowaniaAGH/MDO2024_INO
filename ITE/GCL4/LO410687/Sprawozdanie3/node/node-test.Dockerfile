FROM node-build
WORKDIR quick-example-of-testing-in-nodejs
RUN npm test
CMD ["npm", "start"]