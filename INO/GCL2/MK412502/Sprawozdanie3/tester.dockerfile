FROM build-app

WORKDIR /express/tmp/foo

RUN npm install

RUN npm test > /test-results.txt
