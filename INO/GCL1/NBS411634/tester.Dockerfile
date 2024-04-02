FROM builder
WORKDIR /tesseract.js-node
RUN npm test
