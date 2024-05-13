FROM build-app

WORKDIR /express/tmp/foo

RUN npm install

RUN npm test --watch > /express/tmp/foo/test-results.txt

FROM node:alpine

COPY --from=builder /express/tmp/foo/test-results.txt /test-results.txt

