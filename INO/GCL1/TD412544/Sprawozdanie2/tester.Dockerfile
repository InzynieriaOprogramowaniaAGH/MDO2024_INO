FROM nodeapp_builder
WORKDIR node-js-dummy-test
RUN npm test
