FROM build-app

WORKDIR express/tmp/foo

CMD ["npm", "start"]

