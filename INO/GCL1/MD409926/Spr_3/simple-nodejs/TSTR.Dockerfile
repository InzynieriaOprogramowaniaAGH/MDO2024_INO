FROM bldr
WORKDIR /simple-nodejs
RUN npm test
CMD ["npm", "start"]