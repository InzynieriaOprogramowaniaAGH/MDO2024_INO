FROM build-app

WORKDIR /express/tmp/foo

RUN npm install

RUN npm test > /express/tmp/foo/test-results.txt
