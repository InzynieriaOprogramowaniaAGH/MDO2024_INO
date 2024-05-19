FROM node-builder

RUN npm test

CMD ["npm", "start"]


