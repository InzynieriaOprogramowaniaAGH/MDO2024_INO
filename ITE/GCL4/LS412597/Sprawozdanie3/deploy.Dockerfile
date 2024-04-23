FROM nodeapp_build

RUN npm run build

EXPOSE 5000

ENTRYPOINT npm run prod