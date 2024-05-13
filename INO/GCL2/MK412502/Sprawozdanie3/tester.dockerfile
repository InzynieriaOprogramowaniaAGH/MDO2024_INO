FROM build-app

WORKDIR /express

RUN npm install

RUN npm test > /express/tmp/foo/test-results.txt
