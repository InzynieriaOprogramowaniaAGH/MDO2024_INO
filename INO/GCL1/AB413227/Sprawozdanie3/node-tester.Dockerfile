FROM bld
WORKDIR /node-js-dummy-test
RUN npm install -g jest
RUN npm run test
